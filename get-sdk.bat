@echo off

rem  --------------------------------------------------------------------------
rem  Downloads the Windows SDK from specified [URL] to [DESTINATION].
rem
rem  Using:
rem
rem    get-sdk [URL] [DESTINATION]
rem
rem  --------------------------------------------------------------------------

setlocal
set root=%~dp0
set sdk_url=%~1
set destination=%~2
set "PATH=%root%utils;%root%sdk;%PATH%"

echo Getting the Windows SDK

:REMOVE_TRAILING_BACKSLASH
if "%destination:~-1,1%" == "\" (
  set "destination=%destination:~,-1%"
  goto :REMOVE_TRAILING_BACKSLASH
)

if "%destination%" == "" (
  echo [ERR][%~n0] Destination is not specified.
  exit /b 1
)

if not exist "%destination%" (
  md "%destination%"
) else echo [WARN][%~n0] Already exist: %destination%

call check-sdk "%destination%" && (
  echo [ERR][%~n0] SDK already exists in %destination%
  exit /b 2
)

set "tmp=%destination%\tmp"

set "components=%tmp%\components"
call check-components "%components%" "%installers%" && goto :COLLECT

set "installers=%tmp%\installers"
call get-installers "%sdk_url%" "%installers%" || exit /b 3
call extract-components "%installers%" "%components%" "%tmp%" || exit /b 4

:COLLECT
call collect-components "%components%" "%destination%" || exit /b 5

call check-sdk "%destination%" || (
  echo [ERR][%~n0] Unable to collect the Windows SDK components!
  exit /b 6
)

rd /q /s "%tmp%" || echo [WARN][%~n0] Unable to delete %tmp%
echo Windows SDK ready.
endlocal
