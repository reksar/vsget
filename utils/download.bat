@echo off

rem  --------------------------------------------------------------------------
rem  Downloads content from [URL] to [OUTFILE] (must be an abs path).
rem
rem  Using:
rem
rem    download [URL] [OUTFILE]
rem
rem  --------------------------------------------------------------------------

setlocal

set url=%~1
set outfile=%~2

call powershell -command ^
  "Invoke-WebRequest -UseBasicParsing -Uri '%url%' -OutFile '%outfile%'"

endlocal
