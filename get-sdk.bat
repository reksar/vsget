@echo off

rem  --------------------------------------------------------------------------
rem  Downloads the Windows SDK ISO from the specified [url] and extracts the
rem  SDK Components to [destination].
rem
rem  Using:
rem
rem    get-sdk [url] [destination]
rem
rem  --------------------------------------------------------------------------

setlocal

call which destination >NUL 2>&1 || set "PATH=%~dp0utils;%PATH%"
call which check-components >NUL 2>&1 || set "PATH=%~dp0sdk;%PATH%"

set url=%~1

if "%url%" == "" (
  echo [ERR][%~n0] SDK URL is required!
  exit /b 1
)

if not "%url:~0,4%" == "http" (
  echo [ERR][%~n0] Invalid SDK URL!
  exit /b 1
)

call destination "%~2" || exit /b 1

call check-components "%destination%" && (
  echo [WARN][%~n0] SDK already exist!
  exit /b 0
)

echo Getting Windows SDK

set "tmp=%destination%\tmp"

set "archiver=%tmp%\7-zip"
call ensure-archiver "%archiver%"

set "installers=%tmp%\installers"
call check-installers "%installers%" && (
  echo [WARN][%~n0] SDK Installers already exists!
  goto :COMPONENTS
)

set "iso=%tmp%\sdk.iso"
call get-iso "%url%" "%iso%" || exit /b 2
call extract-installers "%iso%" "%installers%" || exit /b 3

:COMPONENTS
call ensure-lessmsi "%tmp%\lessmsi" || exit /b 4
set "components=%tmp%\components"
call extract-components "%installers%" "%components%" || exit /b 5
call collect-components "%components%" "%destination%" || exit /b 6
call check-components "%destination%" || (
  echo [ERR][%~n0] Failed to get Windows SDK!
  exit /b 7
)

rd /q /s "%tmp%" >NUL 2>&1 || echo [WARN][%~n0] Unable to delete "%tmp%"!

echo.
endlocal
