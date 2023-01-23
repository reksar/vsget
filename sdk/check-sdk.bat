@echo off
setlocal
set destination=%~1
set "lib_dir=%destination%\Windows Kits"
set lib_files="%lib_dir%\*.lib" "%lib_dir%\*.h"
set list_lib=dir /b /s %lib_files%
set find_lib=findstr /p /n /e /c:"\.lib" /c:"\.h"
if exist "%lib_dir%" (
  for /f "tokens=1 delims=:" %%i in ('%list_lib% ^| %find_lib%') do (
    if %%i GTR 0 (
      exit /b 0
    )
  )
)
exit /b 1
endlocal
