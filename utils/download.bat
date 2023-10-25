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
call which destination >NUL 2>&1 || set "PATH=%root%;%PATH%"

rem  Ensure the %outfile% dir exists.
for %%i in ("%outfile%") do if not exist "%%~dpi" md "%%~dpi"

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
  curl --silent --location ^
    --user-agent "Mozilla/4.0 (compatible; Win32; WinHttp.WinHttpRequest.5)" ^
    --output "%outfile%" "%url%" ^
    && exit /b 0 ^
    || exit /b 1
)

rem  * MS JScript
call which cscript >NUL 2>&1 && (
  cscript /nologo "%root%download.js" "%url%" "%outfile%" >NUL 2>&1 ^
    && exit /b 0
)

rem  * PowerShell
rem  TODO: check if `WebRequest` is available.
set silent=Set-Variable ProgressPreference SilentlyContinue
set request=Invoke-WebRequest -UseBasicParsing -Uri '%url%' -OutFile '%outfile%'
call which powershell >NUL 2>&1 && (
  powershell -command "%silent% ; %request%" >NUL 2>&1 ^
    && exit /b 0 ^
    || exit /b 1
)

echo [ERR][%~n0] Downloading failed! Make sure curl is available.
exit /b 3

endlocal
