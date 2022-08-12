@echo off

rem  -------------------------------------------------------------------------
rem  Using: `uncache [PACKAGES GROUP] [PACKAGES PATH PATTERNS ...]`.
rem  Creates a `%root%\%group%.%version%.bat` downloader for given packages
rem  %path_patterns% in the Visual Studio cache. A group name can be arbitrary.
rem  -------------------------------------------------------------------------

setlocal EnableDelayedExpansion
set root=%~dp0..
set PATH=%PATH%;%root%\utils


rem  --- Parse args ----------------------------------------------------------

set group=%~1

if "%group%"=="" (
  echo [ERR] Packages group is not set.
  goto :END
)

echo Creating downloader for %group%:

rem  All remaining args are path patterns for VS packages cache dirs.
rem  NOTE: using an array instead of a list for the %path_patterns% and %dirs%
rem  allows iterating over dir names containing separators, e.g. spaces and
rem  commas.

set /a pattern_count=0
set path_patterns=
:PATTERNS
shift
if not "%~1"=="" (
  set /a pattern_count+=1
  set path_patterns[!pattern_count!]=%~1
  goto :PATTERNS
)

if %pattern_count% EQU 0 (
  echo [ERR] Can't count given Visual Studio packages path patterns.
  goto :END
)

for /l %%i in (1,1,%pattern_count%) do (
  echo   !path_patterns[%%i]!
)


rem  -------------------------------------------------------------------------

echo|set/p=Searching for cached Visual Studio %group% packages ... 

set /a dir_count=0
set dirs=

for /l %%i in (1,1,%pattern_count%) do (
  for /d %%j in ("!path_patterns[%%i]!") do (
    set /a dir_count+=1
    set dirs[!dir_count!]=%%j
  )
)

if %dir_count% NEQ %pattern_count% (
  echo.
  echo   [ERR] Inconsistent count of package patterns and matched dirs.
  echo   Probably some packages were not found or several versions were found.
  goto :END
)

echo OK


rem  -------------------------------------------------------------------------

echo|set/p=Reading first found package version ... 

set VERSION_PATTERN=\d+\.\d+\.\d+.\d*
set get_version=call strmatch "%VERSION_PATTERN%" -txt

rem  Take version of first found package.
for /f %%i in ('%get_version% "%dirs[1]%"') do (
  set version=%%i
)

if "%version%"=="" (
  echo.
  echo   [ERR] Can't read package version.
  goto :END
)

echo OK

echo|set/p=Checking whole packages group is of version %version% ... 

rem  Compare next packages versions with first version.
for /l %%i in (2,1,%dir_count%) do (
  for /f %%j in ('%get_version% !dirs[%%i]!') do (
    if not "%%j"=="%version%" (
      echo.
      echo   [ERR] Inconsistent packages versions.
      goto :END
    )
  )
)

echo OK


rem  -------------------------------------------------------------------------

echo|set/p=Reading packages URLs from info files ... 

rem  Each `_package.json` is expected to contain exacly one URL matching this
set VSIX_URL_PATTERN=https:\/\/.*\.vsix
set get_url=call strmatch "%VSIX_URL_PATTERN%" -file
set urls=

for /l %%i in (1,1,%dir_count%) do (

  set info_file=!dirs[%%i]!\_package.json

  if not exist "!info_file!" (
    echo.
    echo   [ERR] Not exists: !info_file!
    goto :END
  )

  for /f %%j in ('%get_url% "!info_file!"') do (
    set urls=!urls! %%j
  )
)

echo OK


rem  --- Create batch downloader ---------------------------------------------

echo|set/p=Writing downloader %group%.%version%.bat ... 

set outfile=%root%\%group%.%version%.bat

if exist "%outfile%" (
  echo.
  echo   [WARN] %outfile% will be overwritten.
  del "%outfile%"
)

rem  VSIX URL suffix.
set VSIX_FILE_PATTERN=[.\w\d]+$
set get_vsix_name=call strmatch "%VSIX_FILE_PATTERN%" -txt

for %%i in (%urls%) do (
  for /f %%j in ('%get_vsix_name% "%%i"') do (
    echo call download %%i "%%~1\%%j" >> "%outfile%"
  )
)

echo DONE


:END
endlocal
