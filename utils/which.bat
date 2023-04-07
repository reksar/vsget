@echo off

rem  --------------------------------------------------------------------------
rem  UNIX-like alternative to the `which` for Windows:
rem
rem    which {executable}
rem
rem  If {executable} exists, prints its path and exits with code 0.
rem  Otherwise, exits silently with code 1.
rem  --------------------------------------------------------------------------

setlocal

set executable=%~1

rem  Try `where` alias for the `powershell` cmdlet (not native for Windows).
where where >NUL 2>&1 && (
  where %executable% 2>NUL && exit /b 0 || exit /b 1
)

rem  Native alternative.
for %%i in (%executable% %executable%.exe %executable%.bat) do (
  if not "%%~$PATH:i" == "" (
    echo %%~$PATH:i
    exit /b 0
  )
)
exit /b 1

endlocal
