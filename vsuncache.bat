@echo off

rem  --------------------------------------------------------------------------
rem  Uncaches each `vsix-uncache\<group>.txt` of VSIX components and writes the
rem  corresponding `vsix-groups\<group>.<version>.txt` for further use:
rem
rem    vsuncache {CachePath}
rem
rem  If the optional `CachePath` is ommited, tries to find the VS cache path in
rem  the Windows Registry.
rem  --------------------------------------------------------------------------

setlocal EnableDelayedExpansion

set URL_PREFIX=https://download.visualstudio.microsoft.com
set REG_PATH=HKLM\SOFTWARE\Microsoft\VisualStudio\Setup
set REG_NAME=CachePath
set "vsget_path=%CD%"

rem  --- Set %cache_path% ------------------------------------------------- {{{
set cache_path=%~1

if "%cache_path%" == "" (

  echo [INFO][%~n0] Detecting the path to the MSVS cache.

  for /f "delims=" %%i in ('
    reg query "%REG_PATH%" /v "%REG_NAME%" ^| findstr /ri "REG_SZ"
  ') do for /f "tokens=2,*" %%j in ("%%i") do set "cache_path=%%k"
)

if "%cache_path%" == "" (
  echo [ERR][%~n0] MSVS cache path is not found!
  goto :EOF
)

if not exist "%cache_path%" (
  echo [ERR][%~n0] MSVS cache path is not exist: "%cache_path%".
  goto :EOF
)

echo [INFO][%~n0] Cache path: "%cache_path%".
rem  ---------------------------------------------------------------------- }}}

for %%i in (%~dp0vsix-uncache\*.txt) do (
  call :PARSE_COMPONENT_PATHS %%i || goto :EOF
  call :READ_GROUP_INFO || goto :EOF
  call :WRITE_RESULT %%i
)
goto :EOF


:PARSE_COMPONENT_PATHS
rem  Adds component paths to the %components% array of size %components_count%.
rem  ---------------------------------------------------------------------- {{{
set txt_file=%1
set components=
set /a components_count=0
rem  Each line %%i in %txt_file% must be a dir name pattern to be searched in
rem  %cache_path%.
echo [INFO][%~n0] Handling group "%~n1":
for /f %%i in (%txt_file%) do (
  for /d %%j in ("%cache_path%\%%i") do (
    echo   %%~nj
    if not exist "%%~j\_package.json" (
      echo [ERR][%~n0] "%%~j\_package.json" is not found^^!
      exit /b 1
    )
    set /a components_count+=1
    set "components[!components_count!]=%%~j"
  )
)
exit /b 0
rem  ---------------------------------------------------------------------- }}}


:READ_GROUP_INFO
rem  Adds component URLs to the %urls% array of size %components_count%.
rem  Reads the %version% of the component group.
rem  ---------------------------------------------------------------------- {{{
set urls=
set version=
for /l %%i in (1,1,!components_count!) do (

  rem  We need to `cd` because we can't double quote the path to
  rem  `_package.json` in `SEARCH_VSIX_URL` below.
  cd /d "!components[%%i]!"

  call :READ_VSIX_URL || (
    cd /d "%vsget_path%"
    exit /b 1
  )
  set urls[%%i]=!url!

  if "!version!" == "" call :READ_VERSION
)
cd /d "%vsget_path%"

if "%version%" == "" (
  echo [ERR][%~n0] Cannot read VSIX group version^^!
  exit /b 2
)

exit /b 0
rem  ---------------------------------------------------------------------- }}}


:READ_VSIX_URL
rem  Reads the !url! of the VSIX component from `_package.json`.
rem  ---------------------------------------------------------------------- {{{
set url=
set /a idx=0
rem  Each component dir has `_package.json` and contains 1 minified long line.
rem  The JSON line is divided below using `delims` and each of these parts %%i
rem  is numbered using %idx%. One of these line parts %%i must be the URL of
rem  the VSIX payload: "url":"%URL_PREFIX%/*.vsix".
:SEARCH_VSIX_URL
set /a idx+=1
for /f "tokens=%idx% delims=,{}[]" %%i in (_package.json) do (
  set url=%%~i
  set url=!url:url":"=!
  rem  Now the !url! will be the unquoted URL, if %%i matches the VSIX payload
  rem  pattern above. If it does not match, goto %%i with the next %idx%.
  if not "!url:~-5!" == ".vsix" goto :SEARCH_VSIX_URL
  if "!url:%URL_PREFIX%=!" == "!url!" goto :SEARCH_VSIX_URL
)
if not "!url:~-5!" == ".vsix" exit /b 1
if "!url:%URL_PREFIX%=!" == "!url!" exit /b 1
exit /b 0
rem  ---------------------------------------------------------------------- }}}


:READ_VERSION
rem  Reads !version! from `_package.json`.
rem  ---------------------------------------------------------------------- {{{
set /a idx=0
rem  Each component dir has `_package.json` and contains 1 minified long line.
rem  The JSON line is divided below using `delims` and each of these parts %%i
rem  is numbered using %idx%. One of these line parts %%i must be the version
rem  of the VSIX component: "version":"<value>".
:SEARCH_VERSION
set /a idx+=1
for /f "tokens=%idx% delims=,{}[]" %%i in (_package.json) do (
  set version=%%~i
  if "!version:version=!" == "!version!" goto :SEARCH_VERSION
  set version=!version:version":"=!
  echo !version!|findstr /r "^[0-9][0-9.]*[0-9]$" >NUL || goto :SEARCH_VERSION
)
exit /b
rem  ---------------------------------------------------------------------- }}}


:WRITE_RESULT
rem  Gets the path %1 to a `vsix-uncache\*.txt` file and writes !urls! to the
rem  corresponding %result_file%.
rem  ---------------------------------------------------------------------- {{{
set group=%~n1
set "result_file=%~dp0vsix-groups\%group%.%version%.txt"
echo     Writing URLs for "%group%.%version%".
if exist "%result_file%" (
  echo     File "%result_file%" will be overwritten^^!
  del "%result_file%" || exit /b 1
)
for /l %%i in (1,1,%components_count%) do (
  echo !urls[%%i]!>> "%result_file%" || exit /b 2
)
exit /b 0
rem  ---------------------------------------------------------------------- }}}


endlocal
