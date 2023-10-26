@echo off

rem  --------------------------------------------------------------------------
rem  Extracts the Windows SDK Installers from the [iso] to the [installers] dir:
rem
rem    extract-installers [iso] [installers]
rem  --------------------------------------------------------------------------

setlocal

set iso=%~1
set installers=%~2
set files_to_extract=Installers\*.msi Installers\*.cab

call which 7z >NUL 2>&1 && (
  echo|set/p=- Extracting SDK Installers ... 
  7z e -y -o"%installers%" "%iso%" -r %files_to_extract% >NUL || (
    echo FAIL
    exit /b 1
  )
  call check-installers "%installers%" || (
    echo FAIL
    exit /b 1
  )
  echo OK
  exit /b 0
)

call extract-installers-from-drive "%iso%" "%installers%" ^
  && exit /b 0 ^
  || exit /b 1

endlocal
