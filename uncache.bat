@echo off

rem  --------------------------------------------------------------------------
rem  Use `uncache [VS CACHE PATH]` to uncache all groups of packages.
rem  --------------------------------------------------------------------------

for /f %%i in ('dir /B "%~dp0uncache"') do (
  if /i not "%%i"=="uncache.bat" (
    call "%~dp0uncache\%%i" %1
  )
)
