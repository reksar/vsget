@echo off

setlocal

set iso_abspath=%~1

if not exist "%iso_abspath%" (
  echo [ERR][%~n0] ISO image not found!
  exit /b 1
)

set mount_iso=Mount-DiskImage -ImagePath '%iso_abspath%' -StorageType ISO
set mount_iso=%mount_iso% -Access ReadOnly

for /f "usebackq" %%i in (`
  call powershell -command "(%mount_iso%).DevicePath"
`) do (
  echo %%i
)

endlocal
