@echo off

setlocal

set zip=%~1
set destination=%~2

call which 7z >NUL 2>&1 && (
  7z x -y -o"%destination%" "%zip%" >NUL || exit /b 1
) || (
  rem  Requires `powershell` v5+
  call powershell -command ^
    "Expand-Archive '%zip%' -DestinationPath '%destination%'" || exit /b 1
)

endlocal
