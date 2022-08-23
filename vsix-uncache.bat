@echo off

rem  --------------------------------------------------------------------------
rem  Use `vsix-uncache [VS CACHE PATH]` to uncache all groups of VSIX packages.
rem  With each `vsix-uncache\*.bat` writes related `vsix-get\*.bat`.
rem  --------------------------------------------------------------------------

for /f %%i in ('dir /b "%~dp0vsix-uncache"') do (
  if /i not "%%i"=="uncache.bat" (
    call "%~dp0vsix-uncache\%%i" %1
  )
)
