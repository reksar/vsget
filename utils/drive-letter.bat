@echo off

setlocal
set device_path=%~1

for /f "usebackq" %%i in (`
  call powershell -command "(Get-DiskImage -DevicePath '%device_path%' | Get-Volume).DriveLetter"
`) do (
  echo %%i
)
endlocal
