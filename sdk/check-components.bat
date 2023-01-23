@echo off

rem  --------------------------------------------------------------------------
rem  Components dir should contain a dir corresponding to each MSI installer.
rem  --------------------------------------------------------------------------

setlocal
set components=%~1
set installers=%~2
call check-installers "%installers%" || exit /b 1
for %%i in ("%installers%\*.msi") do (
  if not exist "%components%\%%~ni" exit /b 2
)
endlocal
