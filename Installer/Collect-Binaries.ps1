Param(
  [string]$RepoRoot = (Resolve-Path ".."),
  [string]$Configuration = "Release",
  [string]$Platform = "x64"
)
$ErrorActionPreference = "Stop"
$Out = Resolve-Path ".\dist\$Platform\$Configuration" -ErrorAction SilentlyContinue
if (-not $Out) { New-Item -ItemType Directory -Force -Path ".\dist\$Platform\$Configuration" | Out-Null; $Out = Resolve-Path ".\dist\$Platform\$Configuration" }
$PluginsOut = Join-Path $Out "Plugins"; New-Item -ItemType Directory -Force -Path $PluginsOut | Out-Null
function Copy-FirstFound($name, $dest) {
  $found = Get-ChildItem -Path $RepoRoot -Recurse -Filter $name -ErrorAction SilentlyContinue |
           Where-Object { $_.FullName -match "\\bin\\$Configuration\\|\\$Configuration\\$Platform\\|\\$Platform\\$Configuration\\" } |
           Select-Object -First 1
  if (-not $found) { $found = Get-ChildItem -Path $RepoRoot -Recurse -Filter $name -ErrorAction SilentlyContinue | Select-Object -First 1 }
  if ($found) { Copy-Item $found.FullName -Destination (Join-Path $dest $name) -Force; Write-Host "OK $name -> $dest" } else { Write-Warning "No se encontró $name" }
}
$names = @("pGinaCredentialProvider.dll","pGina.Service.ServiceHost.exe","pGina.Configuration.exe","pGina.CredentialProvider.Registration.exe")
foreach ($n in $names) { Copy-FirstFound $n $Out }
$plugins = @("pGina.Plugin.MySQLAuth.dll","pGina.Plugin.MySqlLogger.dll","pGina.Plugin.LocalMachine.dll")
foreach ($p in $plugins) { Copy-FirstFound $p $PluginsOut }
Write-Host "Staging creado en: $Out"
