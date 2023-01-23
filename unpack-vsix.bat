@echo off

rem  --------------------------------------------------------------------------
rem  Unpacks all `*.vsix` files stored in [DESTINATION]. Extracts only the
rem  contents of the `Contents` dir of each `*.vsix` package and puts it to
rem  [DESTINATION].
rem
rem  Using:
rem
rem    unpack-vsix [DESTINATION]
rem
rem  --------------------------------------------------------------------------

setlocal EnableDelayedExpansion
set root=%~dp0
set "PATH=%root%utils;%PATH%"

set destination=%~1

if "%destination%" == "" (
  echo [ERR][%~n0] Destination is not specified.
  exit /b 1
)

if not exist "%destination%" (
  echo [ERR][%~n0] Destination is not exist: %destination%
  exit /b 2
)

:REMOVE_TRAILING_BACKSLASH
if "%destination:~-1,1%" == "\" (
  set "destination=%destination:~,-1%"
  goto :REMOVE_TRAILING_BACKSLASH
)

set "tmp=%destination%\tmp"

echo Unpacking

for %%i in ("%destination%\*.vsix") do (

  echo   %%~ni
  set "zip=%%~dpni.zip"
  move "%%i" "!zip!" >NUL
  call unzip "!zip!" "%tmp%"

  robocopy "%tmp%\Contents" "%destination%" * /S /NFL /NDL /NJH /NJS >NUL

  rem  Delete all files in %tmp% dir.
  del /Q /S "%tmp%\*.*" >NUL

  rem  Delete all dirs in %tmp% dir.
  for /d %%j in ("%tmp%\*") do (
    rd /Q /S "%%j"
  )

  del "!zip!"
)

rd "%tmp%" 2>NUL

endlocal
