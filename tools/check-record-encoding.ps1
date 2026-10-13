# Record-file encoding check (see SKILLS.md SOP-005, CAPA.md NC-012).
# Detects UTF-8 double-encoding (the C3 A2 / C2 A0 byte pairs) and a UTF-8 BOM
# in the root record files. Reads raw bytes - never through PowerShell string
# cmdlets, which would re-encode and corrupt what they are meant to check.
# Exit 0 = clean, 1 = at least one file regressed.
[CmdletBinding()]
param([string] $Root = '')

$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($Root)) {
    $scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }
    $Root = Split-Path -Parent $scriptDir
}
Set-Location $Root

$files = 'AGENTS.md','PROGRESS.md','SKILLS.md','DECISIONS.md','BUILD-SPEC.md',
         'TASK-PLAN.md','CODE-FIX-PLAN.md','DATABASE.md','CAPA.md','README.md',
         'ARTICLES-HANDLING.md','URL-INVENTORY.md','SECURITY-NOTES.md'

$fails = @()
foreach ($f in $files) {
    if (-not (Test-Path $f)) { continue }
    $bytes = [System.IO.File]::ReadAllBytes((Resolve-Path $f).Path)
    $bom = ($bytes.Length -ge 3 -and
            $bytes[0] -eq [byte]0xEF -and $bytes[1] -eq [byte]0xBB -and $bytes[2] -eq [byte]0xBF)
    $mb = 0
    for ($i = 0; $i -lt $bytes.Length - 1; $i++) {
        $a = [int]$bytes[$i]; $b = [int]$bytes[$i + 1]
        if (($a -eq 0xC3 -and $b -eq 0xA2) -or ($a -eq 0xC2 -and $b -eq 0xA0)) { $mb++ }
    }
    if ($bom -or $mb -gt 0) {
        Write-Host ("FAIL  {0,-24} mojibake={1} bom={2}" -f $f, $mb, $bom) -ForegroundColor Red
        $fails += $f
    } else {
        Write-Host ("PASS  {0,-24} clean" -f $f) -ForegroundColor Green
    }
}

Write-Host ""
if ($fails.Count -eq 0) {
    Write-Host "RECORD-ENCODING: PASS - no double-encoding or BOM" -ForegroundColor Green
    exit 0
} else {
    Write-Host ("RECORD-ENCODING: FAIL - {0} file(s): {1}" -f $fails.Count, ($fails -join ', ')) -ForegroundColor Red
    exit 1
}
