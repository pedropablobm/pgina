;
; pGina Installer for VS2022 (subset of plugins)
#define AppName "pGina (VS2022)"
#define AppVersion "3.2.0-vs2022"
#define InstallDir "{pf}\pGina"
#define StagingDir ".\dist\x64\Release"

[Setup]
AppId={{3A6E1A39-7B0B-4B87-A1A5-0BEF9B21B7B2}
AppName={#AppName}
AppVersion={#AppVersion}
DefaultDirName={#InstallDir}
ArchitecturesInstallIn64BitMode=x64
PrivilegesRequired=admin
OutputDir=.
OutputBaseFilename=pgina-setup-vs2022

[Files]
Source: "{#StagingDir}\pGinaCredentialProvider.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#StagingDir}\pGina.Service.ServiceHost.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#StagingDir}\pGina.Configuration.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#StagingDir}\pGina.CredentialProvider.Registration.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#StagingDir}\Plugins\pGina.Plugin.MySQLAuth.dll"; DestDir: "{app}\Plugins"; Flags: ignoreversion
Source: "{#StagingDir}\Plugins\pGina.Plugin.MySqlLogger.dll"; DestDir: "{app}\Plugins"; Flags: ignoreversion
Source: "{#StagingDir}\Plugins\pGina.Plugin.LocalMachine.dll"; DestDir: "{app}\Plugins"; Flags: ignoreversion

[Run]
Filename: "{app}\pGina.CredentialProvider.Registration.exe"; Parameters: "/register"; Flags: runhidden
Filename: "sc.exe"; Parameters: "create pGinaService binPath= ""{app}\pGina.Service.ServiceHost.exe"" start= auto"; Flags: runhidden; Check: not ServiceExists('pGinaService')
Filename: "sc.exe"; Parameters: "start pGinaService"; Flags: runhidden

[Code]
function ServiceExists(const Name: string): Boolean;
var ResultCode: Integer;
begin
  Result := (ShellExec('', 'sc.exe', 'query ' + Name, '', SW_HIDE, ewWaitUntilTerminated, ResultCode)) and (ResultCode = 0);
end;
