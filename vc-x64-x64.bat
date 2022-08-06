@echo off
setlocal
set root=%~dp0
set PATH=%PATH%;%root%utils


rem  --- Parse args ----------------------------------------------------------

rem  First arg is always destination dir.
set destination=%~1

if "%destination%"=="" (
  echo [ERR] Destination dir is not set.
  goto :END
)

rem  Second arg is optional `*.bat` downloader.
if "%~2"=="" (
  rem  Set default vc-x64-x64 downloader
  for %%i in (%root%vc-x64-x64.*.bat) do (
    rem  Looping until latest version matches the pattern.
    set downloader=%%i
  )
) else (
  set downloader=%~2
)

if not exist "%downloader%" (
  echo [ERR] Downloader is not found: %downloader%
  goto :END
)

echo Download MS Visual C++
echo   with %downloader%
echo   to %destination%


rem  --- Download packages ---------------------------------------------------
rem  TODO: check if %destination% is dir

if not exist "%destination%" (
  mkdir "%destination%"
)

call "%downloader%" "%destination%"


:END
endlocal
