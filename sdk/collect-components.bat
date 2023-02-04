@echo off

rem  --------------------------------------------------------------------------
rem  Moves the content from the `SourceDir` of each Component to %destination%.
rem  --------------------------------------------------------------------------

setlocal

set components=%~1
set destination=%~2

echo   Collecting SDK components

for /d %%i in ("%components%\*") do (

  if exist "%%i\SourceDir" (

    echo     %%~ni
    robocopy "%%i\SourceDir" "%destination%" * /S /MOV /NFL /NDL /NJH /NJS >NUL

    if %ERRORLEVEL% NEQ 0 (
      echo   [ERR][%~n0] Unable to move SDK Component!
      exit /b 1
    )
  ) else echo     [SKIP] %%~ni

  rd /q /s "%%i" >NUL 2>&1 || echo [WARN][%~n0] Unable to delete %%i
)

rd /q /s "%components%" >NUL 2>&1 || ^
  echo [WARN][%~n0] Unable to delete "%components%"

exit /b 0

endlocal
