# tools/phase-report.ps1
# Generates a self-contained HTML dashboard of the project records:
# phase progress (TASK-PLAN.md), the gate journal (PROGRESS.md), locked
# decisions (DECISIONS.md), nonconformities (CAPA.md) and build statuses
# (BUILD-SPEC.md). It also embeds the running site so the demo is visible.
#
# Usage:
#   powershell -ExecutionPolicy Bypass -File tools\phase-report.ps1
#   powershell -ExecutionPolicy Bypass -File tools\phase-report.ps1 -SiteUrl http://localhost:3000/ -OutFile .preview\phase-report.html
#
# Read-only: it never edits a record file. Output defaults under .preview\ (gitignored).

param(
    [string]$Root = (Split-Path -Parent $PSScriptRoot),
    [string]$SiteUrl = 'http://localhost:3000/',
    [string]$ApiUrl = 'http://localhost:8080/api/articles?page=0&size=5',
    [string]$OutFile
)

$ErrorActionPreference = 'Stop'
$enc = New-Object System.Text.UTF8Encoding($false)

if (-not $OutFile) { $OutFile = Join-Path $Root '.preview\phase-report.html' }
if (-not [System.IO.Path]::IsPathRooted($OutFile)) { $OutFile = Join-Path $Root $OutFile }

function Read-Record([string]$name) {
    $p = Join-Path $Root $name
    if (Test-Path $p) { return [System.IO.File]::ReadAllLines($p, $enc) }
    return @()
}

function Html([string]$s) {
    if ($null -eq $s) { return '' }
    $s = $s -replace '&', '&amp;' -replace '<', '&lt;' -replace '>', '&gt;'
    return $s
}

function Test-Port([string]$u) {
    try {
        $uri = [Uri]$u
        $c = New-Object Net.Sockets.TcpClient
        $c.Connect($uri.Host, $uri.Port)
        $c.Close()
        return $true
    } catch { return $false }
}

# --- phase progress from TASK-PLAN.md -------------------------------------
$taskLines = Read-Record 'TASK-PLAN.md'
$phases = New-Object System.Collections.Generic.List[object]
$cur = $null
foreach ($line in $taskLines) {
    if ($line -match '^##\s+Phase\s+(\d+)\s*[^A-Za-z]*\s*(.*)$') {
        if ($cur) { $phases.Add($cur) }
        $cur = [pscustomobject]@{ Num = [int]$Matches[1]; Title = $Matches[2].Trim(); Done = 0; Total = 0; Smoke = '' }
    } elseif ($cur -and $line -match '^\s*-\s+\[( |x|X|~|!)\]') {
        $cur.Total++
        if ($Matches[1] -match '[xX]') { $cur.Done++ }
    } elseif ($cur -and $line -match '^\*\*Smoke test') {
        $cur.Smoke = ($line -replace '^\*\*Smoke test[^:]*:\*\*\s*', '').Trim()
    }
}
if ($cur) { $phases.Add($cur) }

# --- gate journal from PROGRESS.md ----------------------------------------
$progLines = Read-Record 'PROGRESS.md'
$gateCounts = @{ M0 = 0; M1 = 0; M2 = 0; M3 = 0; M4 = 0; M5 = 0; M6 = 0 }
$entries = New-Object System.Collections.Generic.List[object]
$e = $null
foreach ($line in $progLines) {
    if ($line -match '^###\s+\[(M[0-9][^\]]*)\]?\s*([0-9]{4}-[0-9]{2}-[0-9]{2})?\s*[-\u2013\u2014]*\s*(.*)$') {
        $gate = 'M' + ($Matches[1] -replace '[^0-9]', '')
        if ($gateCounts.ContainsKey($gate)) { $gateCounts[$gate]++ }
        if ($e) { $entries.Add($e) }
        $e = [pscustomobject]@{ Gate = $gate; Date = $Matches[2]; Title = $Matches[3].Trim(); Status = ''; Views = '' }
    } elseif ($e) {
        if ($line -match '^\s*-\s+\*\*Status:\*\*\s*(.+)$') { $e.Status = $Matches[1].Trim() }
        elseif ($line -match '^\s*-\s+\*\*Views:\*\*\s*(.+)$') { $e.Views = $Matches[1].Trim() }
    }
}
if ($e) { $entries.Add($e) }

# --- decisions -------------------------------------------------------------
$decisions = New-Object System.Collections.Generic.List[object]
foreach ($line in (Read-Record 'DECISIONS.md')) {
    if ($line -match '^##\s+(D-\d+)\s*[-\u2013\u2014]*\s*(.+)$') {
        $decisions.Add([pscustomobject]@{ Id = $Matches[1]; Title = $Matches[2].Trim() })
    }
}

# --- nonconformities -------------------------------------------------------
$ncs = New-Object System.Collections.Generic.List[object]
$nc = $null
foreach ($line in (Read-Record 'CAPA.md')) {
    if ($line -match '^##\s+(NC-\d+)\s*[-\u2013\u2014]*\s*(.+)$') {
        if ($nc) { $ncs.Add($nc) }
        $nc = [pscustomobject]@{ Id = $Matches[1]; Title = $Matches[2].Trim(); Status = 'unknown' }
    } elseif ($nc -and $line -match '^\s*-\s+\*\*Status:\*\*\s*(.+)$') {
        $nc.Status = ($Matches[1].Trim() -split '\s')[0].ToLower()
    }
}
if ($nc) { $ncs.Add($nc) }

# --- build spec statuses ---------------------------------------------------
$specCounts = @{ 'as-built-verified' = 0; 'built' = 0; 'specified' = 0 }
foreach ($line in (Read-Record 'BUILD-SPEC.md')) {
    if ($line -match '^\|\s*\d+\s*\|' -and $line -match '\|') {
        if ($line -match 'as-built-verified') { $specCounts['as-built-verified']++ }
        elseif ($line -match '\|\s*built') { $specCounts['built']++ }
        elseif ($line -match '\|\s*specified') { $specCounts['specified']++ }
    }
}

# --- live checks -----------------------------------------------------------
$siteUp = Test-Port $SiteUrl
$apiUp = Test-Port $ApiUrl
$guardKit = 'n/a'; $guardTable = 'n/a'
try { $o = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $Root 'tools\check-record-kit.ps1') 2>&1; $guardKit = if (($o -join "`n") -match 'PASS') { 'PASS' } else { 'FAIL' } } catch {}
try { $o = & powershell -NoProfile -ExecutionPolicy Bypass -File (Join-Path $Root 'tools\check-forbidden-tables.ps1') 2>&1; $guardTable = if (($o -join "`n") -match 'PASS') { 'PASS' } else { 'FAIL' } } catch {}

function Bar([int]$done, [int]$total) {
    $pct = if ($total -gt 0) { [int](100 * $done / $total) } else { 0 }
    $cls = if ($pct -ge 100) { 'ok' } elseif ($pct -gt 0) { 'part' } else { 'none' }
    return "<div class='bar'><span class='$cls' style='width:$pct%'></span></div><div class='pct'>$pct% ($done/$total)</div>"
}

$gen = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')

$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('<!doctype html><html lang="en"><head><meta charset="utf-8">')
[void]$sb.AppendLine('<meta name="viewport" content="width=device-width, initial-scale=1">')
[void]$sb.AppendLine('<title>VivaLanka revamp - phase dashboard</title>')
[void]$sb.AppendLine(@'
<style>
:root{--deep:#07056a;--accent:#0066cc;--bright:#1e90ff;--ink:#111827;--mut:#6b7280;--line:#e5e7eb;--bg:#f6f8fc;--ok:#16a34a;--part:#f59e0b;--none:#cbd5e1;}
*{box-sizing:border-box}
body{margin:0;font:15px/1.5 "Segoe UI",Roboto,Arial,sans-serif;color:var(--ink);background:var(--bg)}
header{background:linear-gradient(120deg,var(--deep),var(--accent));color:#fff;padding:22px 28px}
header h1{margin:0 0 4px;font-size:22px}
header .meta{opacity:.85;font-size:13px}
.wrap{max-width:1080px;margin:0 auto;padding:22px 18px 60px}
.grid{display:grid;grid-template-columns:1fr 1fr;gap:16px}
@media(max-width:820px){.grid{grid-template-columns:1fr}}
.card{background:#fff;border:1px solid var(--line);border-radius:12px;padding:16px 18px;margin-bottom:16px}
.card h2{margin:0 0 12px;font-size:16px;color:var(--deep)}
.phase{border:1px solid var(--line);border-radius:10px;padding:10px 12px;margin-bottom:10px}
.phase .t{display:flex;justify-content:space-between;font-weight:600;font-size:14px}
.bar{height:8px;background:#eef2f7;border-radius:99px;overflow:hidden;margin:8px 0 3px}
.bar span{display:block;height:100%}
.bar .ok{background:var(--ok)}.bar .part{background:var(--part)}.bar .none{background:var(--none)}
.pct{font-size:12px;color:var(--mut)}
.pill{display:inline-block;font-size:11px;padding:2px 8px;border-radius:99px;border:1px solid var(--line);margin:0 4px 4px 0;background:#f9fafb}
.pill.D{background:#eef6ff;border-color:#cfe4ff}
.pill.NC-open{background:#fef2f2;border-color:#fecaca;color:#b91c1c}
.pill.NC-closed{background:#f0fdf4;border-color:#bbf7d0;color:#15803d}
table{width:100%;border-collapse:collapse;font-size:13px}
th,td{text-align:left;padding:6px 8px;border-bottom:1px solid var(--line);vertical-align:top}
th{color:var(--mut);font-weight:600}
.kpis{display:flex;gap:10px;flex-wrap:wrap}
.kpi{background:#fff;border:1px solid var(--line);border-radius:10px;padding:10px 14px;min-width:120px}
.kpi b{display:block;font-size:22px;color:var(--accent)}
.kpi span{font-size:12px;color:var(--mut)}
.host{display:inline-block;width:9px;height:9px;border-radius:50%;margin-right:6px}
.up{background:var(--ok)}.down{background:#dc2626}
a{color:var(--accent)}
iframe{width:100%;height:520px;border:1px solid var(--line);border-radius:10px;background:#fff}
.links a{margin-right:12px;font-size:13px}
code{background:#f3f4f6;padding:1px 5px;border-radius:5px;font-size:12px}
</style>
'@)
[void]$sb.AppendLine('</head><body>')
[void]$sb.AppendLine("<header><h1>VivaLanka revamp &mdash; phase dashboard</h1>")
[void]$sb.AppendLine("<div class='meta'>Generated $gen &middot; source: PROGRESS.md, TASK-PLAN.md, DECISIONS.md, CAPA.md, BUILD-SPEC.md (read-only) &middot; repo C:\rcwebapp</div></header>")
[void]$sb.AppendLine("<div class='wrap'>")

# live status + links
[void]$sb.AppendLine("<div class='card'><h2>Live local stack</h2><div class='kpis'>")
[void]$sb.AppendLine("<div class='kpi'><b><span class='host $(if($siteUp){'up'}else{'down'})'></span>$(if($siteUp){'UP'}else{'DOWN'})</b><span>frontend &middot; $SiteUrl</span></div>")
[void]$sb.AppendLine("<div class='kpi'><b><span class='host $(if($apiUp){'up'}else{'down'})'></span>$(if($apiUp){'UP'}else{'DOWN'})</b><span>backend &middot; $ApiUrl</span></div>")
[void]$sb.AppendLine("<div class='kpi'><b>$guardKit</b><span>record-kit guard</span></div>")
[void]$sb.AppendLine("<div class='kpi'><b>$guardTable</b><span>forbidden-table guard</span></div>")
[void]$sb.AppendLine("</div><p class='links' style='margin:12px 0 0'><a href='$SiteUrl' target='_blank'>Open home</a><a href='$SiteUrl/newspage/12272011ai-court-rejects-shiranthi-s-bail-application' target='_blank'>Open sample article</a><a href='$ApiUrl' target='_blank'>Open API JSON</a></p></div>")

# phase timeline
[void]$sb.AppendLine("<div class='card'><h2>Phase roadmap (TASK-PLAN.md)</h2>")
foreach ($p in ($phases | Sort-Object Num)) {
    [void]$sb.AppendLine("<div class='phase'><div class='t'><span>Phase $($p.Num) &mdash; $(Html $p.Title)</span></div>$(Bar $p.Done $p.Total)")
    if ($p.Smoke) { [void]$sb.AppendLine("<div class='pct'>smoke test: $(Html $p.Smoke)</div>") }
    [void]$sb.AppendLine("</div>")
}
[void]$sb.AppendLine("</div>")

[void]$sb.AppendLine("<div class='grid'>")

# journal
[void]$sb.AppendLine("<div class='card'><h2>Gate journal (PROGRESS.md)</h2>")
[void]$sb.AppendLine("<div class='kpis' style='margin-bottom:10px'>")
foreach ($g in 'M0','M1','M2','M3','M4','M5','M6') { [void]$sb.AppendLine("<div class='kpi'><b>$($gateCounts[$g])</b><span>$g</span></div>") }
[void]$sb.AppendLine("</div><table><tr><th>Gate</th><th>Date</th><th>Entry</th></tr>")
foreach ($x in ($entries | Select-Object -Last 8)) {
    [void]$sb.AppendLine("<tr><td>$($x.Gate)</td><td>$($x.Date)</td><td>$(Html $x.Title)<br><span class='pct'>$(Html $x.Status)</span></td></tr>")
}
[void]$sb.AppendLine("</table></div>")

# build status
[void]$sb.AppendLine("<div class='card'><h2>Build status (BUILD-SPEC.md)</h2>")
[void]$sb.AppendLine("<div class='kpis'>")
[void]$sb.AppendLine("<div class='kpi'><b>$($specCounts['as-built-verified'])</b><span>as-built-verified</span></div>")
[void]$sb.AppendLine("<div class='kpi'><b>$($specCounts['built'])</b><span>built</span></div>")
[void]$sb.AppendLine("<div class='kpi'><b>$($specCounts['specified'])</b><span>specified</span></div>")
[void]$sb.AppendLine("</div><p class='pct' style='margin-top:12px'>Only <code>as-built-verified</code> claims it works, and only with evidence. Current verified scope: backend API on WildFly, sitemaps/robots, and the Phase 2 + Phase 3 frontend.</p></div>")

[void]$sb.AppendLine("</div>") # grid

# decisions
[void]$sb.AppendLine("<div class='card'><h2>Locked decisions &mdash; $($decisions.Count) (DECISIONS.md)</h2>")
foreach ($d in $decisions) { [void]$sb.AppendLine("<span class='pill D' title='$(Html $d.Title)'>$($d.Id)</span>") }
[void]$sb.AppendLine("</div>")

# CAPA
$openNc = ($ncs | Where-Object { $_.Status -eq 'open' }).Count
[void]$sb.AppendLine("<div class='card'><h2>Nonconformities &mdash; $($ncs.Count) total, $openNc open (CAPA.md)</h2>")
foreach ($n in $ncs) { [void]$sb.AppendLine("<span class='pill NC-$($n.Status)' title='$(Html $n.Title)'>$($n.Id) $(Html $n.Title)</span>") }
[void]$sb.AppendLine("</div>")

# embedded demo
[void]$sb.AppendLine("<div class='card'><h2>Live demo (embedded)</h2>")
if ($siteUp) {
    [void]$sb.AppendLine("<iframe src='$SiteUrl' title='VivaLanka local demo' loading='lazy'></iframe>")
    [void]$sb.AppendLine("<p class='pct'>Embedded from $SiteUrl. If the frame is blocked, use the links above.</p>")
} else {
    [void]$sb.AppendLine("<p class='pct'>Frontend is not running. Start it (see AGENTS.md) then regenerate this report.</p>")
}
[void]$sb.AppendLine("</div>")

[void]$sb.AppendLine("</div></body></html>")

$dir = Split-Path -Parent $OutFile
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
[System.IO.File]::WriteAllText($OutFile, $sb.ToString(), $enc)
Write-Output "phase-report: wrote $OutFile"
Write-Output ("phases={0} decisions={1} ncs={2} gates(M0..M6)={3} site={4} api={5}" -f $phases.Count, $decisions.Count, $ncs.Count, (($gateCounts.Values | Measure-Object -Sum).Sum), $siteUp, $apiUp)
