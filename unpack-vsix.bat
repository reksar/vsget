@echo off

rem  --------------------------------------------------------------------------
rem  Unpacks all VSIX files stored in [DESTINATION]. Extracts only the contents
rem  of the `Contents` dir of each VSIX package and puts it to [DESTINATION].
rem
rem  Using:
rem
rem    unpack-vsix [DESTINATION]
rem
rem  --------------------------------------------------------------------------

setlocal
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

rem  When `EnableDelayedExpansion` is enabled, some path names may not work
rem  correctly, such as those containing the unescaped "!". Change working dir
rem  before `EnableDelayedExpansion`.
set "origin_path=%CD%"
cd "%destination%"

echo Unpacking Contents from all VSIX
setlocal EnableDelayedExpansion
for %%i in ("*.vsix") do (
  echo   %%~ni
  set "zip=%%~ni.zip"
  move "%%i" "!zip!" >NUL
  call unzip "!zip!" tmp
  del "!zip!"
  robocopy tmp\Contents . * /S /MOV /NFL /NDL /NJH /NJS >NUL
  rd /s /q tmp 2>NUL
)
endlocal

rem  Restore after delayed expansion.
cd "%origin_path%"

endlocal
