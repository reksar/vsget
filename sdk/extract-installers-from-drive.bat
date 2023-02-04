@echo off

rem  --------------------------------------------------------------------------
rem  Deprecated!
rem  Extracts Windows SDK installers from mounted ISO to %destination%.
rem  --------------------------------------------------------------------------

setlocal

set iso=%~1
set destination=%~2

echo [WARN][%~n0] Mounting ISO as disk drive!
for /f %%i in ('call drive-mount "%iso%"') do set "device_path=%%i"
for /f %%i in ('call drive-letter "%device_path%"') do set "drive=%%i"

call check-installers "%drive%:\Installers" || (
  echo [ERR][%~n0] SDK Installers not found on drive "%drive%"!
  exit /b 1
)

if not exist "%destination%" md "%destination%"

echo|set/p=- Extracting SDK installers ... 
for %%i in ("%drive%:\Installers\*") do (
  copy "%%i" "%destination%" >NUL || (
    echo FAIL
    call drive-umount "%device_path%"
    exit /b 1
  )
)
echo OK

call drive-umount "%device_path%"

endlocal
