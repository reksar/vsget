@echo off

rem  --------------------------------------------------------------------------
rem  Downloads the VSIX package of a MSVC component, extracts the `Contents` to
rem  [destination].
rem
rem  Using:
rem
rem    get-vsix-group [group] [destination]
rem
rem  --------------------------------------------------------------------------

setlocal

set group=%~1
set destination=%~2

set "group_file=%~dp0vsix-groups\%group%.txt"

if not exist "%group_file%" (
  echo [ERR][%~n0] VSIX group not found: "%group%"!
  exit /b 1
)

echo Getting %group%

for /f "usebackq" %%i in ("%group_file%") do (
  call get-vsix %%i "%destination%" || exit /b 2
)

echo.

endlocal
