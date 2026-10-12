<#
.SYNOPSIS
  URL-contract regression harness (Phase 0).

.DESCRIPTION
  Walks tools/url-inventory/url-contract.json and checks that every frozen URL
  resolves with the expected status against a target base URL. Run it against
  the live site now (baseline), and against the new app after cutover - the same
  list must produce the same statuses (D-003).

  Only the HTTP status (and Location for redirects) is compared, not the body,
  so the same contract works for legacy and the new stack.

  The default curl User-Agent is blocked by the edge WAF with 403, so a browser
  User-Agent is sent by default.

.PARAMETER BaseUrl
  Root to test against. Default https://www.vivalanka.com (the live baseline).

.PARAMETER OnlyCritical
  Check only entries flagged critical.

.EXAMPLE
  pwsh -File tools/url-contract.ps1
  pwsh -File tools/url-contract.ps1 -BaseUrl http://localhost:3000 -OnlyCritical
#>
[CmdletBinding()]
param(
    [string] $BaseUrl = 'https://www.vivalanka.com',
    [string] $Manifest = '',
    [switch] $OnlyCritical,
    [int] $TimeoutSec = 30,
    [int] $DelayMs = 900,
    [int] $Retries = 3,
    [string] $UserAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36'
)

$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($Manifest)) {
    $scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
    $Manifest = Join-Path $scriptDir 'url-inventory\url-contract.json'
}
if (-not (Test-Path $Manifest)) { throw "Manifest not found: $Manifest" }
$contract = Get-Content -Raw $Manifest | ConvertFrom-Json
$base = $BaseUrl.TrimEnd('/')

$entries = $contract.urls
if ($OnlyCritical) { $entries = $entries | Where-Object { $_.critical -eq $true } }

$results = @()

function Get-StatusCode {
    param([string] $Target, [string] $Agent, [int] $Timeout, [int] $MaxRetries, [int] $Delay)
    for ($attempt = 0; $attempt -le $MaxRetries; $attempt++) {
        $curlArgs = @('-sS', '-o', 'NUL', '-D', '-', '--max-time', $Timeout, '-A', $Agent, $Target)
        $raw = & curl.exe @curlArgs 2>&1
        $statusLine = ($raw | Select-String -Pattern '^HTTP/' | Select-Object -Last 1).Line
        $code = if ($statusLine -match 'HTTP/\S+\s+(\d{3})') { [int]$Matches[1] } else { 0 }
        if ($code -ne 429 -or $attempt -eq $MaxRetries) {
            return [pscustomobject]@{ Code = $code; Raw = $raw }
        }
        # Back off on rate limiting, then retry.
        Start-Sleep -Milliseconds ($Delay * ($attempt + 2))
    }
}

foreach ($e in $entries) {
    $target = "$base$($e.url)"
    $resp = Get-StatusCode -Target $target -Agent $UserAgent -Timeout $TimeoutSec -MaxRetries $Retries -Delay $DelayMs
    $code = $resp.Code
    $location = ($resp.Raw | Select-String -Pattern '^location:' -CaseSensitive:$false | Select-Object -Last 1).Line

    $expected = if ($e.expect) { [int]($e.expect -replace '\D','') } else { 200 }
    $ok = ($code -eq $expected)

    # Some endpoints (e.g. /rcsearch/) answer a crawler but block a browser UA.
    $botCode = $null
    if ($e.PSObject.Properties.Name -contains 'expectBot') {
        $botResp = Get-StatusCode -Target $target -Agent 'Googlebot/2.1 (+http://www.google.com/bot.html)' -Timeout $TimeoutSec -MaxRetries $Retries -Delay $DelayMs
        $botCode = $botResp.Code
        if ($botCode -ne [int]$e.expectBot) { $ok = $false }
    }

    $results += [pscustomobject]@{
        Id       = $e.id
        Url      = $e.url
        Expected = $expected
        Actual   = $code
        Bot      = $botCode
        Ok       = $ok
        Location = ($location -replace '^location:\s*','')
    }

    Start-Sleep -Milliseconds $DelayMs
}

$fail = @($results | Where-Object { -not $_.Ok })
Write-Host ""
Write-Host ("URL contract vs {0}  ({1} checked)" -f $base, $results.Count) -ForegroundColor Cyan
$results | ForEach-Object {
    $line = "{0,-22} exp {1}  got {2}  {3}" -f $_.Id, $_.Expected, $_.Actual, $_.Url
    if ($null -ne $_.Bot) { $line += "  [bot $($_.Bot)]" }
    if ($_.Location) { $line += "  -> $($_.Location)" }
    if ($_.Ok) { Write-Host $line } else { Write-Host $line -ForegroundColor Red }
}
Write-Host ""

if ($fail.Count -gt 0) {
    Write-Host ("FAIL - {0}/{1} URL(s) did not match" -f $fail.Count, $results.Count) -ForegroundColor Red
    exit 1
}
Write-Host ("PASS - all {0} URL(s) match the contract" -f $results.Count) -ForegroundColor Green
exit 0
