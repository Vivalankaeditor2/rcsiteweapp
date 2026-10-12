# Record-system conformance check (see zenodo/interns_secret_general.md).
# Runs the kit's "Self-check before handover" and "Definition of done" on the
# root record files. Exit 0 = all pass, 1 = at least one failed line.
[CmdletBinding()]
param([string] $Root = '')

$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($Root)) {
    $scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
    $Root = Split-Path -Parent $scriptDir
}
Set-Location $Root

$ten = 'AGENTS.md','PROGRESS.md','SKILLS.md','DECISIONS.md','BUILD-SPEC.md',
       'TASK-PLAN.md','CODE-FIX-PLAN.md','DATABASE.md','CAPA.md','README.md'
$fails = @()

function Check([string] $name, [bool] $ok, [string] $detail) {
    if ($ok) { Write-Host ("PASS  {0}" -f $name) -ForegroundColor Green }
    else { Write-Host ("FAIL  {0}  {1}" -f $name, $detail) -ForegroundColor Red; $script:fails += $name }
}

# 1. All 10 files exist at the project root.
$missing = $ten | Where-Object { -not (Test-Path $_) }
Check 'all ten record files exist at root' ($missing.Count -eq 0) ($missing -join ', ')

# 2. AGENTS.md states the project type.
$agents = Get-Content AGENTS.md -Raw
Check 'AGENTS.md states the project type' ($agents -match '\*\*Type:\*\*\s*`?(Software Development|Other)`?') 'no "Type:" line'

# Read the docs once (root *.md, excluding the kit itself).
$docs = Get-ChildItem -Filter *.md | Where-Object { $_.Name -ne 'interns_secret_general.md' }

# A "defined" id is one that a document introduces as a heading, so the kit's
# own format templates do not count.
function Get-DefinedIds([string] $pattern) {
    $ids = @{}
    foreach ($d in $docs) {
        $t = Get-Content $d.FullName -Raw
        [regex]::Matches($t, "(?m)^#+\s*($pattern)") | ForEach-Object { $ids[$_.Groups[1].Value] = $true }
    }
    $ids
}
function Get-ReferencedIds([string] $pattern) {
    $ids = @{}
    foreach ($d in $docs) {
        $t = Get-Content $d.FullName -Raw
        [regex]::Matches($t, "\b($pattern)\b") | ForEach-Object { $ids[$_.Groups[1].Value] = $true }
    }
    $ids
}

# 3-5. Every named SOP/NC/D resolves to a real entry.
$sopDef = Get-DefinedIds 'SOP-\d{3}'; $sopRef = Get-ReferencedIds 'SOP-\d{3}'
$ncDef  = Get-DefinedIds 'NC-\d{3}';  $ncRef  = Get-ReferencedIds 'NC-\d{3}'
$dDef   = Get-DefinedIds 'D-\d{3}';   $dRef   = Get-ReferencedIds 'D-\d{3}'
$dangSop = $sopRef.Keys | Where-Object { -not $sopDef.ContainsKey($_) } | Sort-Object
$dangNC  = $ncRef.Keys  | Where-Object { -not $ncDef.ContainsKey($_) }  | Sort-Object
$dangD   = $dRef.Keys   | Where-Object { -not $dDef.ContainsKey($_) }   | Sort-Object
Check 'every SOP-NNN resolves to SKILLS.md' ($dangSop.Count -eq 0) ($dangSop -join ', ')
Check 'every NC-NNN resolves to CAPA.md'    ($dangNC.Count -eq 0)  ($dangNC -join ', ')
Check 'every D-NNN resolves to DECISIONS.md' ($dangD.Count -eq 0)  ($dangD -join ', ')

# 6. PROGRESS.md has an entry for every gate that fired.
$prog = Get-Content PROGRESS.md -Raw
$gates = [regex]::Matches($prog, '(?m)^###\s*\[(M\d)[^\]]*\]') | ForEach-Object { $_.Groups[1].Value }
Check 'PROGRESS.md has a session-open (M0) entry' ($gates -contains 'M0') 'no M0 entry'
Check 'PROGRESS.md has a session-close (M6) entry' ($gates -contains 'M6') 'no M6 entry'

# 9. Every PROGRESS.md entry has a Views field.
$entryCount = [regex]::Matches($prog, '(?m)^###\s*\[').Count
$viewsCount = [regex]::Matches($prog, '(?m)^-\s*\*\*Views:\*\*').Count
Check 'every PROGRESS.md entry has a Views field' ($entryCount -eq $viewsCount) "$entryCount entries vs $viewsCount Views fields"

# 8. Each record file has a Duty line.
$noDuty = @()
foreach ($f in $ten | Where-Object { $_ -ne 'PROGRESS.md' -and $_ -ne 'README.md' }) {
    if ((Get-Content $f -Raw) -notmatch '\*\*Duty:\*\*') { $noDuty += $f }
}
Check 'each record file declares a Duty' ($noDuty.Count -eq 0) ($noDuty -join ', ')

# 7. No credential VALUE appears in any root file (names/locations only).
#    Placeholders and variable references are fine; a real secret is not.
$secret = Get-ChildItem -Recurse -File -Include *.md,*.ps1,*.json,*.yml,*.properties,*.cli |
    Where-Object { $_.FullName -notmatch '\\rcsiteweb\\|\\.git\\|\\zenodo\\' } |
    Select-String -Pattern '(?i)(password|passwd|secret|api[_-]?key|token)\s*[:=]\s*["'']([^"'']{6,})["'']' -ErrorAction SilentlyContinue |
    Where-Object {
        $v = $_.Matches[0].Groups[2].Value
        # Ignore obvious placeholders: <...>, ${...}, $env:..., CHANGE_ME, example, your-...
        $v -notmatch '^[<$\{]' -and $v -notmatch '(?i)change_?me|example|your[_-]|placeholder|xxxx'
    }
Check 'no credential value in the tracked files' ($null -eq $secret) 'see the lines above'

Write-Host ''
if ($fails.Count -gt 0) {
    Write-Host ("RECORD-KIT: FAIL - {0} line(s)" -f $fails.Count) -ForegroundColor Red
    exit 1
}
Write-Host 'RECORD-KIT: PASS - the record set conforms' -ForegroundColor Green
exit 0
