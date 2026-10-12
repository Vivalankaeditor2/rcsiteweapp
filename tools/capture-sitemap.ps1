$ErrorActionPreference = 'Continue'
$root = 'C:\rcwebapp'
$UA = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0 Safari/537.36'
$dir = Join-Path $root 'tools\sitemaps'
New-Item -ItemType Directory -Force -Path $dir | Out-Null

$idxPath = Join-Path $root 'tools\legacy-capture\sitemapindex.xml'
if (-not (Test-Path $idxPath)) {
    curl.exe -sS --max-time 40 -A $UA 'https://www.vivalanka.com/sitemapindex.xml' -o $idxPath
}
$idx = Get-Content -Raw $idxPath
$locs = [regex]::Matches($idx, '<loc>(.*?)</loc>') | ForEach-Object { $_.Groups[1].Value }
$shards = $locs | Where-Object { $_ -match 'sitemap_(\d+)\.xml' }
Write-Output "shards in index: $($shards.Count)"

$outShards = Join-Path $dir 'shards.txt'
$shards | Set-Content $outShards -Encoding utf8

function Sample-Urls {
    param([string[]] $Urls, [int] $Each)
    $byPattern = @{}
    foreach ($u in $Urls) {
        $path = ''
        try { $path = ([uri]$u).AbsolutePath } catch { continue }
        $key = $path -replace '/\d+', '/{n}'
        if ($key -notmatch '^/newspage/') {
            $key = $key -replace '/[A-Za-z0-9\-_]{4,}', '/{slug}'
        }
        if (-not $byPattern.ContainsKey($key)) { $byPattern[$key] = @() }
        if ($byPattern[$key].Count -lt $Each) { $byPattern[$key] += $u }
    }
    $byPattern.GetEnumerator() | ForEach-Object { [pscustomobject]@{ Shape = $_.Key; Count = $_.Value.Count; Examples = ($_.Value -join ' | ') } }
}

# Oldest shard (legacy .jsp shapes) with samples.
$allSamples = @()
foreach ($s in @($shards[0], $shards[[math]::Floor($shards.Count/2)], $shards[-1])) {
    curl.exe -sS --max-time 40 -A $UA $s -o (Join-Path $dir 'current.xml')
    Start-Sleep -Milliseconds 800
    $xml = Get-Content -Raw (Join-Path $dir 'current.xml')
    $u = [regex]::Matches($xml, '<loc>(.*?)</loc>') | ForEach-Object { $_.Groups[1].Value }
    Write-Output ("{0} -> {1} urls" -f $s, $u.Count)
    $allSamples += $u
}
Remove-Item (Join-Path $dir 'current.xml') -ErrorAction SilentlyContinue

$allSamples | Select-Object -Unique | Set-Content (Join-Path $dir 'sampled-urls.txt') -Encoding utf8
Write-Output ""
Write-Output "=== URL shapes seen (examples) ==="
Sample-Urls -Urls $allSamples -Each 3 | Sort-Object Shape | Format-Table -AutoSize | Out-String -Width 400
