@echo off

rem  --------------------------------------------------------------------------
rem  Extracts the Windows SDK Installers from the [ISO] to the [INSTALLERS] dir.
rem
rem  Using:
rem
rem    extract-installers [ISO] [INSTALLERS]
rem  --------------------------------------------------------------------------

setlocal

set iso=%~1
set installers=%~2

call which 7z >NUL 2>&1 && (
  echo|set/p=- Extracting SDK Installers ... 
  set files=Installers\*.msi Installers\*.cab
  7z e -y -o"%installers%" "%iso%" -r %files% >NUL || (
    echo FAIL
    exit /b 1
  )
  echo OK
  goto :END
)

call extract-installers-from-drive "%iso%" "%installers%" || exit /b 1

:END
del /q /s "%iso%" >NUL 2>&1 || echo [WARN][%~n0] Unable to delete "%iso%"!
exit /b 0

endlocal
