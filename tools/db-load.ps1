<#
.SYNOPSIS
  Load the frozen schema + seed config into the local MariaDB.

.DESCRIPTION
  Runs dbschema.sql (31 CREATE TABLEs) then the db/001-016 seed files
  (config INSERTs only - no personal data) into a local MariaDB.

  Two paths are supported, in order of preference:
    1. mysql.exe on PATH (or -MysqlExe) - works with any reachable server.
    2. If Docker is available and no -Host given, use the compose service.

  The schema file is copied, not moved, and is never written to (D-014).

.PARAMETER DBHost
  MariaDB host. Default 127.0.0.1 (the local stack).

.EXAMPLE
  pwsh -File tools/db-load.ps1 -User root -Password (Read-Host -AsSecureString)
#>
[CmdletBinding()]
param(
    [string] $DBName    = 'vivalanka',
    [string] $DBHost    = '127.0.0.1',
    [int]    $Port      = 3306,
    [string] $User      = 'root',
    [string] $Password  = '',
    [string] $MysqlExe  = '',
    [string] $SchemaFile = (Resolve-Path (Join-Path $PSScriptRoot '..\rcsiteweb\db\dbschema.sql')).Path,
    [string] $SeedDir    = (Resolve-Path (Join-Path $PSScriptRoot '..\rcsiteweb\db')).Path
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $SchemaFile)) { throw "Schema not found: $SchemaFile" }

if (-not $MysqlExe) {
    $cmd = Get-Command mysql -ErrorAction SilentlyContinue
    if ($cmd) { $MysqlExe = $cmd.Source }
}

if (-not $MysqlExe) {
    Write-Host "mysql.exe not found. Start the compose stack and run this inside the container:" -ForegroundColor Yellow
    Write-Host "  docker compose -f tools/local-stack/docker-compose.yml up -d mariadb"
    Write-Host "  docker compose -f tools/local-stack/docker-compose.yml exec -T mariadb sh -c \`"mysql -uroot -p`$MARIADB_ROOT_PASSWORD $DBName < /docker-entrypoint-initdb.d/00-dbschema.sql\`""
    exit 2
}

$pwdArg = if ($Password) { "-p$Password" } else { '' }
$commonArgs = @('-h', $DBHost, '-P', $Port, '-u', $User)
if ($pwdArg) { $commonArgs += $pwdArg }

Write-Host "Creating database $DBName (if missing)..."
& $MysqlExe @commonArgs -e "CREATE DATABASE IF NOT EXISTS ``$DBName`` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;"
if ($LASTEXITCODE -ne 0) { throw "CREATE DATABASE failed" }

Write-Host "Loading schema: $SchemaFile"
& $MysqlExe @commonArgs $DBName -e "SOURCE $($SchemaFile -replace '\\','/');"
if ($LASTEXITCODE -ne 0) { throw "Schema load failed" }

$seeds = Get-ChildItem -Path $SeedDir -Filter '0*.sql' | Sort-Object Name
foreach ($seed in $seeds) {
    Write-Host "Seeding: $($seed.Name)"
    & $MysqlExe @commonArgs $DBName -e "SOURCE $($seed.FullName -replace '\\','/');"
    if ($LASTEXITCODE -ne 0) { throw "Seed failed: $($seed.Name)" }
}

Write-Host "Done. Tables:" -ForegroundColor Green
& $MysqlExe @commonArgs $DBName -e "SHOW TABLES;"
