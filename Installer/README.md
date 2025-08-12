# Installer (VS2022) — subset de plugins
- Crea staging en `Installer\dist\x64\Release` y genera `pgina-setup-vs2022.exe` con Inno Setup 6.
- Si solo compilaste en VS, usa `Collect-Binaries.ps1`; si quieres compilar+empaquetar en un paso, usa `Build-Installer.ps1`.
- Si tu política de ejecución bloquea scripts, usa:
  ```powershell
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Build-Installer.ps1 -Configuration Release -Platform x64
  ```
