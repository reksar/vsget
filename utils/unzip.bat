@echo off

setlocal

set zip=%~1
set destination=%~2

call which which >NUL 2>&1 || set "PATH=%~dp0;%PATH%"

call which 7z >NUL 2>&1 && (
  7z x -y -o"%destination%" "%zip%" >NUL || exit /b 1
) || (

  call which powershell >NUL 2>&1 || (
    echo [ERR][%~n0] PowerShell or 7-zip not found!
    exit /b 2
  )

  rem  TODO: Check if PowerShell version is >= 5

  rem  TODO: Process subdirs recursively.
  powershell -command ^
    "Expand-Archive -LiteralPath '%zip%' -DestinationPath '%destination%'" ^
    || exit /b 3
)

endlocal
