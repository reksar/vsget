@echo off

rem  --------------------------------------------------------------------------
rem  Ensures the %destination% is set to an absolute path without trailing
rem  backslashes and creates the corresponding dir if necessary.
rem  --------------------------------------------------------------------------

set destination=%~1

if "%destination%" == "" (
  echo [ERR][%~n0] Destination is not specified!
  exit /b 1
)

:REMOVE_TRAILING_BACKSLASH
if "%destination:~-1,1%" == "\" (
  set "destination=%destination:~,-1%"
  goto :REMOVE_TRAILING_BACKSLASH
)

if "%destination%" == "" (
  echo [ERR][%~n0] Bad destination!
  exit /b 2
)

for %%i in ("%destination%") do set "destination=%%~fi"

if not exist "%destination%" md "%destination%" || (
  echo [ERR][%~n0] Unable to create "%destination%"!
  exit /b 3
)

exit /b 0
