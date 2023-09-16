@echo off

rem  --------------------------------------------------------------------------
rem  Downloads content from [url] to [outfile] (abs path):
rem
rem    download [url] [outfile]
rem
rem  --------------------------------------------------------------------------

setlocal DisableDelayedExpansion

set url=%~1
set outfile=%~2
set root=%~dp0

if "%outfile%" == "" (
  echo [ERR][%~n0] Outfile is not set!
  exit /b 1
)

if exist "%outfile%" (
  echo [ERR][%~n0] Already exist: "%outfile%".
  exit /b 2
)

rem  Utility preset.
call which which >NUL 2>&1 || set "PATH=%root%;%PATH%"

rem  Creating intermediate dirs.
for %%i in ("%outfile%") do if not exist "%%~pi" md "%%~pi"

rem  Trying to download with:

rem  * curl
call which curl >NUL 2>&1 || (
  rem  * curl from Git for Windows
  for /f %%i in ('which git') do (
    for %%j in (%%~dpi..) do (
      set "bin_dir=%%~fj\mingw64\bin"
    )
  )
  "%bin_dir%\curl" --version >NUL 2>&1 && set "PATH=%bin_dir%;%PATH%"
)
call which curl >NUL 2>&1 && (
  call curl %url% --output "%outfile%" --silent ^
    && exit /b 0 ^
    || exit /b 1
)

rem  * MS JScript
call which cscript >NUL 2>&1 && (
  call cscript /nologo "%root%download.js" "%url%" "%outfile%" ^
    >NUL 2>&1 ^
    && exit /b 0
)

rem  * PowerShell
call which powershell >NUL 2>&1 && (
  rem  TODO: check if `WebRequest` is available.
  call powershell -command ^
    "Invoke-WebRequest -UseBasicParsing -Uri '%url%' -OutFile '%outfile%'" ^
    >NUL 2>&1 ^
    && exit /b 0 ^
    || exit /b 1
)

echo [ERR][%~n0] Downloading failed! Make sure curl is available.
exit /b 3

endlocal
