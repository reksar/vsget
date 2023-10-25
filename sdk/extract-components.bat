@echo off

rem  --------------------------------------------------------------------------
rem  Extracts the Windows SDK Components from installers (MSI and CAB files)
rem  located in the [installers] dir into the [components] dir.
rem
rem  The [components] dir will contain subdirs corresponding to each source
rem  MSI file.
rem
rem  Using:
rem
rem    extract-components [installers] [components]
rem  --------------------------------------------------------------------------

setlocal

set installers=%~1
set components=%~2

rem  The `lessmsi` may have errors when using some complicated paths.
rem  To prevent them, we need to change the workdir to %components% and then
rem  use relative paths. Before doing this, we need to save the %origin_path%
rem  and ensure that %installers% is an abs path.
set "origin_path=%CD%"
for %%i in ("%installers%") do set "installers=%%~fi"
if not exist "%components%" md "%components%"
cd /d "%components%"

rem  Check this after cd %components%!
call check-installers "%installers%" || (
  echo [ERR][%~n0] No installers found!
  exit /b 1
)

call which lessmsi >NUL 2>&1 || (
  echo [ERR][%~n0] Executable `lessmsi` not found!
  exit /b 2
)

rem  Used only to suppress output from `lessmsi` to stdout.
if exist lessmsi.log (
  del /q /s lessmsi.log >NUL 2>&1 && (
    echo [WARN][%~n0] The old lessmsi.log has been deleted!
  ) || (
    echo [WARN][%~n0] Failed to delete lessmsi.log!
  )
)

echo - Extracting SDK Components

for %%i in ("%installers%\*.msi") do (
  if not exist "%%~ni" (
    echo -   %%~ni
    lessmsi x "%%i" >> lessmsi.log || (
      echo [ERR][%~n0] Unable to extract SDK Component!
      echo [INFO][%~n0] See "%components%\lessmsi.log".
      cd /d "%origin_path%"
      exit /b 3
    )
  ) else echo -   [WARN] Already exist: %%~ni
)

echo.

del /q /s *.duplicate* >NUL 2>&1
del /q /s lessmsi.log >NUL 2>&1
rd /q /s "%installers%" >NUL 2>&1
cd /d "%origin_path%"

endlocal
