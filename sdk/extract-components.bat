@echo off

rem  --------------------------------------------------------------------------
rem  Extracts Windows SDK components from MSI installers.
rem  --------------------------------------------------------------------------

setlocal
set installers_dir=%~1
set components_dir=%~2
set tmp=%~3


set "lessmsi_dir=%tmp%\lessmsi"
set "lessmsi_log=%lessmsi_dir%\lessmsi.log"
call get-lessmsi "%lessmsi_dir%" || exit /b 1
set "PATH=%lessmsi_dir%;%PATH%"


if exist "%lessmsi_log%" (
  echo [WARN][sdk] Deleting old lessmsi log!
  del "%lessmsi_log%"
)


echo Extracting SDK components ...

rem  NOTE: `lessmsi` has issues with path name encoding: only Latin symbols are
rem  available for the target dir for extraction. When a path name error
rem  occurs, `lessmsi` uses the %CD% path instead.
rem
rem  Changing %CD% instead of passing the target dir arg to `lessmsi` to
rem  achieve the same effect even on path name error.
set "origin_path=%CD%"
if not exist "%components_dir%" md "%components_dir%"
cd "%components_dir%"

for %%i in ("%installers_dir%\*.msi") do (

  if not exist "%components_dir%\%%~ni" (

    echo   %%~ni

    rem  NOTE: suppressing output by redirecting the to %lessmsi_log%.
    lessmsi x "%%i" >> "%lessmsi_log%" || (
      echo [ERR][%~n0] Unable to extract SDK component from MSI!
      exit /b 2
    )
  ) else echo   [WARN][%~n0] %%~ni already exist!
)

rem  Duplicates may be created by `lessmsi` during MSI extraction.
del /q /s *.duplicate* >NUL 2>&1

cd "%origin_path%"

call check-components "%components_dir%" "%installers_dir%" || (
  echo [ERR][%~n0] Unable to extract SDK components!
  exit /b 3
)
endlocal
