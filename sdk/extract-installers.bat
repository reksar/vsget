@echo off

setlocal

set sdk_iso=%~1
set installers_dir=%~2

for /f %%i in ('call drive-mount "%sdk_iso%"') do (
  set "device_path=%%i"
)

for /f %%i in ('call drive-letter "%device_path%"') do (
  set "drive=%%i"
)

echo|set/p=Extracting SDK installers ... 

for %%i in ("%drive%:\Installers\*") do (
  copy "%%i" "%installers_dir%" >NUL || (
    echo FAIL
    exit /b 1
  )
)
echo OK

call drive-umount "%device_path%"

endlocal
