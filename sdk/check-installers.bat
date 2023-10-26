@echo off
setlocal

set destination=%~1
if not exist "%destination%" exit /b 1

rem  The %PATH% to system `find` may be overwritten by third-party utils.
set find=%SystemRoot%\System32\find.exe
if not exist "%find%" (
  echo [ERR][%~n0] System `find` not found!
  exit /b 2
)

set count_files=dir /b "%destination%" ^^^| "%find%" /c /i
for /f %%i in ('%count_files% ".msi"') do (
  for /f %%j in ('%count_files% ".cab"') do (
    if %%i GTR 0 (
      if %%i LEQ %%j (
        exit /b 0
      ) else echo [WARN][%~n0] Suspiciously few CAB files associated with MSI.
    ) else echo [WARN][%~n0] MSI installers not found.
  )
)
exit /b 3

endlocal
