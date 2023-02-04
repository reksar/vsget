@echo off

setlocal

set destination=%~1
if not exist "%destination%" exit /b 1

set count_files=dir /b "%destination%" ^^^| find /c /i

for /f %%i in ('%count_files% ".msi"') do (
  for /f %%j in ('%count_files% ".cab"') do (
    if %%i GTR 0 (
      if %%i LEQ %%j (
        exit /b 0
      ) else echo [WARN][%~n0] Suspiciously few CAB files associated with MSI.
    ) else echo [WARN][%~n0] MSI installers not found.
  )
)
exit /b 2

endlocal
