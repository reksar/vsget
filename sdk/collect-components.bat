@echo off

rem  --------------------------------------------------------------------------
rem  Moves the content of each component's SourceDir to %destination%.
rem  --------------------------------------------------------------------------

setlocal
set components=%~1
set destination=%~2

echo Collecting SDK components ...

for /d %%i in ("%components%\*") do (

  if exist "%%i\SourceDir" (

    robocopy "%%i\SourceDir" "%destination%" * /S /NFL /NDL /NJH /NJS /MOV >NUL

    if %ERRORLEVEL% EQU 0 (
      echo   %%~ni
    ) else (
      echo   [ERR][%~n0] %%~ni
      exit /b 1
    )
  )
  rd /q /s "%%i" || echo [WARN][%~n0] Unable to delete %%i
)
endlocal
