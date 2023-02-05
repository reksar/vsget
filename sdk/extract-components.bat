@echo off

rem  --------------------------------------------------------------------------
rem  Extracts the Windows SDK Components from the [INSTALLERS] dir (MSI and CAB
rem  files) to [COMPONENTS] dir. The [COMPONENTS] dir will contain subdirs
rem  corresponding to each MSI.
rem
rem  Using:
rem
rem    extract-components [INSTALLERS] [COMPONENTS]
rem
rem  --------------------------------------------------------------------------

setlocal

set installers=%~1
set components=%~2

call which lessmsi >NUL 2>&1 || (
  echo [ERR][%~n0] Requires `lessmsi`!
  exit /b 1
)

rem  Only used to suppress output from `lessmsi` to stdout.
set "lessmsi_log=%components%\lessmsi.log"

if exist "%lessmsi_log%" (
  del /q /s "%lessmsi_log%" >NUL 2>&1 && (
    echo [WARN][%~n0] The old "%lessmsi_log%" has been deleted!
  ) || (
    echo [WARN][%~n0] Failed to delete "%lessmsi_log%"!
  )
)

rem  To prevent `lessmsi` path errors.
set "origin_path=%CD%"
if not exist "%components%" md "%components%"
cd "%components%"

echo - Extracting SDK Components

for %%i in ("%installers%\*.msi") do (
  if not exist "%components%\%%~ni" (
    echo -   %%~ni
    lessmsi x "%%i" >> "%lessmsi_log%" || (
      echo [ERR][%~n0] Unable to extract SDK Component!
      cd "%origin_path%"
      exit /b 2
    )
  ) else echo -   [WARN] Already exist: %%~ni
)

echo.

rem  Duplicates may be created during MSI extraction.
del /q /s *.duplicate* >NUL 2>&1

cd "%origin_path%"

del /q /s "%lessmsi_log%" >NUL 2>&1
rd /q /s "%installers%" >NUL 2>&1

endlocal
