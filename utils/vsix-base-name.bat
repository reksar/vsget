@echo off

rem  --------------------------------------------------------------------------
rem  Extracts the VSIX base name (without the file extension) from [URL] and
rem  outputs it to stdout.
rem
rem  Using:
rem
rem    vsix-name [URL]
rem
rem  --------------------------------------------------------------------------

setlocal EnableDelayedExpansion

set VSIX_FILE_PATTERN=[.\w\d]+$
set get_vsix_name=call strmatch "%VSIX_FILE_PATTERN%" -txt

rem  This name is not unique, so it must to be replaced with a hash.
set DEFAULT_NAME=payload.vsix

set HASH_PATTERN=/[\w\d]+/
set get_vsix_hash=call strmatch "%HASH_PATTERN%" -txt

set url=%~1

for /f %%i in ('%get_vsix_name% "%url%"') do (
  if /i "%%i" == "%DEFAULT_NAME%" (
    for /f %%j in ('%get_vsix_hash% "%url%"') do (
      set hash=%%j
      echo !hash:~1,7!
    )
  ) else echo %%~ni
)

endlocal
