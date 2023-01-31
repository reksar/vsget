@echo off

rem  --------------------------------------------------------------------------
rem  Sets the %destination% var and creates the associated dir if needed.
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

if not exist "%destination%" md "%destination%"

exit /b 0
