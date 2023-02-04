@echo off

setlocal

set device_path=%~1
set get_disk=Get-DiskImage -DevicePath '%device_path%'

for /f "usebackq" %%i in (`
  call powershell -command "(%get_disk% | Get-Volume).DriveLetter"
`) do (
  echo %%i
)

endlocal
