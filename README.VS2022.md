# pGina — VS2022 (fixes incluidos)
- .NET 4.8 en proyectos C#
- MySql.Data 8.4.0 + log4net 2.0.15 (PackageReference)
- TLS en MySQLAuth (`SslMode=Required` o `AllowPublicKeyRetrieval` si no hay TLS)
- **afxres.h → winres.h** en recursos (evita MFC)
- **Solution Filter** `pGina.vs2022.slnf` para abrir un subconjunto (sin Gina/FakeWinlogon)

## Compilar
1. Abre `pGina.vs2022.slnf` en VS2022 (o la solución original y desmarca Gina/FakeWinlogon).
2. Restaura NuGet y compila `Release | x64`.

## Instalador
Ve a `Installer/` y ejecuta:
```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Build-Installer.ps1 -Configuration Release -Platform x64
```
Generará `Installer\pgina-setup-vs2022.exe`.
