<#
.SYNOPSIS
  Guard for D-019: fail if a forbidden table is referenced in source.

.DESCRIPTION
  `article_category_has_articles` is owned by another process (the Solr indexer /
  commerce). The news application must not read, write, or build code against it.
  This script scans the given trees and exits non-zero on any hit, so it can run
  in CI. The JUnit test `ForbiddenTableUsageTest` enforces the same rule in the
  backend build; this script also covers the legacy tree and the frontend today.

.EXAMPLE
  pwsh -File tools/check-forbidden-tables.ps1
#>
[CmdletBinding()]
param(
    [string[]] $Forbidden = @('article_category_has_articles'),
    [string[]] $Paths     = @('backend/src/main', 'frontend', 'rcsiteweb/src', 'rcsiteweb/ROOT'),
    [string[]] $Extensions = @('.java', '.jsp', '.sql', '.xml', '.properties', '.yml', '.yaml', '.ts', '.tsx', '.js', '.jsx'),
    # Files that legitimately name a forbidden table (the guard itself, docs).
    [string[]] $ExcludePatterns = @('ForbiddenTableUsageTest')
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$offenders = @()

foreach ($relative in $Paths) {
    $full = Join-Path $root $relative
    if (-not (Test-Path $full)) { continue }

    $files = Get-ChildItem -Path $full -Recurse -File -ErrorAction SilentlyContinue |
        Where-Object { $Extensions -contains $_.Extension } |
        Where-Object { $p = $_.FullName; -not ($ExcludePatterns | Where-Object { $p -like "*$_*" }) }

    foreach ($file in $files) {
        $text = Get-Content -Raw -LiteralPath $file.FullName -ErrorAction SilentlyContinue
        if ($null -eq $text) { continue }
        foreach ($name in $Forbidden) {
            if ($text.Contains($name)) {
                $offenders += [pscustomobject]@{
                    Table = $name
                    File  = $file.FullName.Substring($root.Length).TrimStart('\', '/')
                }
            }
        }
    }
}

if ($offenders.Count -gt 0) {
    Write-Host "FAIL - forbidden table reference(s) found (D-019):" -ForegroundColor Red
    $offenders | ForEach-Object { Write-Host ("  {0}  ->  {1}" -f $_.Table, $_.File) }
    exit 1
}

Write-Host ("PASS - no forbidden table reference found. Scanned: {0}" -f ($Paths -join ', ')) -ForegroundColor Green
exit 0
