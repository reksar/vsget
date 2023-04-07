@echo off

rem  --------------------------------------------------------------------------
rem  Downloads content from {url} to {outfile} (must be an abs path):
rem
rem    download {url} {outfile}
rem
rem  --------------------------------------------------------------------------

setlocal DisableDelayedExpansion

set url=%~1
set outfile=%~2

if "%outfile%" == "" (
  echo [ERR][%~n0] Outfile is not set!
  exit /b 1
)

if exist "%outfile%" (
  echo [ERR][%~n0] Already exist: "%outfile%".
  exit /b 2
)

for %%i in ("%outfile%") do if not exist "%%~pi" md "%%~pi"

set root=%~dp0

rem  Prefer this method, because MS JScript is more native than `powershell`.
call which cscript >NUL 2>&1 && (
  call cscript /nologo "%root%download.js" "%url%" "%outfile%" ^
    >NUL 2>&1 && exit /b 0 || exit /b 1
)

rem  Deprecated! Downloading with `powershell`.
call which which >NUL 2>&1 || set "PATH=%root%;%PATH%"
call which powershell >NUL 2>&1 && (
  call powershell -command ^
    "Invoke-WebRequest -UseBasicParsing -Uri '%url%' -OutFile '%outfile%'" ^
      >NUL 2>&1 && exit /b 0 || exit /b 1
)

echo [ERR][%~n0] cscript and powershell are not available!
exit /b 3

endlocal
