@echo off

setlocal
set iso_abspath=%~1

if not exist "%iso_abspath%" (
  echo [ERR][iso-mount] ISO image not found.
  exit /b 1
)

for /f "usebackq" %%i in (`
  call powershell -command "(Mount-DiskImage -ImagePath '%iso_abspath%' -StorageType ISO -Access ReadOnly).DevicePath"
`) do (
  echo %%i
)
endlocal
