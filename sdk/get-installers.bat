@echo off

rem  --------------------------------------------------------------------------
rem  Gets MSI installers for Windows SDK components from %sdk_url% and puts
rem  them to %installers_dir%.
rem  --------------------------------------------------------------------------

setlocal
set sdk_url=%~1
set installers_dir=%~2

call check-installers "%installers_dir%" && (
  echo [WARN][%~n0] SDK installers already exist!
  exit /b 0
)

if not exist "%installers_dir%" md "%installers_dir%"

set "sdk_iso=%installers_dir%\sdk.iso"
call get-iso "%sdk_url%" "%sdk_iso%" || exit /b 1
call extract-installers "%sdk_iso%" "%installers_dir%" || exit /b 2

call check-installers "%installers_dir%" || (
  echo [ERR][%~n0] Unable to extract SDK installers from ISO!
  exit /b 3
)
endlocal
