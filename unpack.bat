@echo off

rem  --------------------------------------------------------------------------
rem  Using: `unpack [DESTINATION DIR]`.
rem  Unpacks all `*.vsix` files stored in `[DESTINATION DIR]`. Extracts only
rem  the contents of the `Contents` dir of each `*.vsix` package and puts in
rem  `[DESTINATION DIR]`.
rem  --------------------------------------------------------------------------


setlocal EnableDelayedExpansion
set root=%~dp0
set PATH=%PATH%;%root%utils

set destination=%~1

if "%destination%"=="" (
  echo [ERR] Destination is not specified.
  goto :END
)

if not exist "%destination%" (
  echo [ERR] Destination is not exists.
  goto :END
)

:SANITIZE
if "%destination:~-1,1%"=="\" (
  set destination=%destination:~,-1%
  goto :SANITIZE
)

set tmp=%destination%\tmp

echo Unpacking

for %%i in (%destination%\*.vsix) do (
  echo   %%~ni
  set zip=%%~dpni.zip
  move "%%i" "!zip!" >NUL
  call unzip "!zip!" "%tmp%"

  robocopy "%tmp%\Contents" "%destination%" * /S /NFL /NDL /NJH /NJS >NUL

  rem  Clear %tmp% dir.
  del /Q /S "%tmp%\*.*" >NUL
  for /d %%j in (%tmp%\*) do (
    rd /Q /S %%j
  )

  del "!zip!"
)

rd "%tmp%" 2>NUL

:END
endlocal
