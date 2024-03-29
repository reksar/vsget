@echo off

rem  --------------------------------------------------------------------------
rem  Third-party util for extracting *.MSI content without its installation.
rem
rem  Using:
rem
rem    ensure-lessmsi [destination]
rem  --------------------------------------------------------------------------

call which lessmsi >NUL 2>&1 && exit /b 0
if exist "%~1\lessmsi.exe" goto :SET_PATH

setlocal

set LESSMSI_VER=v1.10.0
set LESSMSI_ZIP=lessmsi-%LESSMSI_VER%.zip
set LESSMSI_DOWNLOAD=https://github.com/activescott/lessmsi/releases/download
set LESSMSI_URL=%LESSMSI_DOWNLOAD%/%LESSMSI_VER%/%LESSMSI_ZIP%

rem  Abs path expected!
call which destination >NUL 2>&1 || set "PATH=%~dp0;%PATH%"
call destination "%~1" || exit /b 1

echo.
echo Getting lessmsi

echo|set/p=- Downloading ... 
call download "%LESSMSI_URL%" "%destination%\%LESSMSI_ZIP%" || (
  echo FAIL
  exit /b 2
)
echo OK

echo|set/p=- Unpacking ... 
call unzip "%destination%\%LESSMSI_ZIP%" "%destination%" || (
  echo FAIL
  exit /b 3
)
echo OK

if not exist "%destination%\lessmsi.exe" (
  echo [ERR][%~n0] Failed to get `lessmsi`!
  exit /b 4
)

echo.
endlocal

:SET_PATH
set "PATH=%~f1;%PATH%"
exit /b 0
