@echo off

setlocal

set exe=%~1

rem  Try `where` first as the easiest way.
rem  NOTE: this is an alias for the `powershell` cmdlet!
where where >NUL 2>&1 && (
  where %exe% 2>NUL && exit /b 0 || exit /b 1
)

rem  Native alternative.
for %%i in (%exe% %exe%.exe %exe%.bat) do (
  if not "%%~$PATH:i" == "" (
    echo %%~$PATH:i
    exit /b 0
  )
)
exit /b 1

endlocal
