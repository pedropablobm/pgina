Param(
  [string]$Configuration = "Release",
  [string]$Platform = "x64",
  [string]$VSWhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe",
  [string]$InnoSetup = "${env:ProgramFiles (x86)}\Inno Setup 6\ISCC.exe"
)

$ErrorActionPreference = "Stop"

# Locate MSBuild
if (-not (Test-Path $VSWhere)) { throw "vswhere.exe no encontrado: $VSWhere" }
$msbuild = & $VSWhere -latest -requires Microsoft.Component.MSBuild -find MSBuild\**\Bin\MSBuild.exe | Select-Object -First 1
if (-not $msbuild) { throw "MSBuild no encontrado" }

# Paths
$RepoRoot = Resolve-Path ".."
$Sln = Join-Path $RepoRoot "pGina\src\pGina-3.x.sln"
$Out = Resolve-Path ".\dist\$Platform\$Configuration" -ErrorAction SilentlyContinue
if (-not $Out) { New-Item -ItemType Directory -Force -Path ".\dist\$Platform\$Configuration" | Out-Null; $Out = Resolve-Path ".\dist\$Platform\$Configuration" }
$PluginsOut = Join-Path $Out "Plugins"; New-Item -ItemType Directory -Force -Path $PluginsOut | Out-Null

# Build
& "$msbuild" $Sln /t:Restore,Build /p:Configuration=$Configuration /p:Platform=$Platform

# Collect artifacts
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

# Build installer
if (-not (Test-Path $InnoSetup)) { throw "Inno Setup 6 ISCC.exe no encontrado: $InnoSetup" }
& "$InnoSetup" ".\pgina_installer.iss"
