@echo off

rem  Using:
rem    uncache [VS cache path] [packages group] [package names ...]

rem  Creates %root%\%group%.%version%.bat downloader for given %packages%
rem  based on Visual Studio cache from given %cache_path%.

setlocal EnableDelayedExpansion
set root=%~dp0..
set PATH=%PATH%;%root%\utils


rem  --- Parse args ----------------------------------------------------------

set cache_path=%~1

if "%cache_path%"=="" (
  echo [ERR] No Visual Studio cache given.
  goto :END
)

if not exist "%cache_path%" (
  echo [ERR] Invalid Visual Studio cache path.
  goto :END
)

shift

set group=%~1

if "%group%"=="" (
  echo [ERR] Packages group is not set.
  goto :END
)

rem  All remaining args are VS package names.
set packages=
:PACKAGES
shift
if not "%1"=="" (
  set packages=%packages% %1
  goto :PACKAGES
)

if "%packages%"=="" (
  echo [ERR] No Visual Studio packages given.
  goto :END
)


echo Visual Studio cache: %cache_path%
echo Creating downloader for %group%:
for %%i in (%packages%) do (
  echo   %%i
)


rem  -------------------------------------------------------------------------

echo|set/p=Building search patterns from package names ... 

set /a package_count=0
set path_patterns=

for %%i in (%packages%) do (
  set /a package_count+=1
  set path_patterns=!path_patterns! %cache_path%\Microsoft.VC.*.%%i*
)

if %package_count% EQU 0 (
  echo.
  echo   [ERR] Can't count given Visual Studio package names.
  goto :END
)

echo OK


rem  -------------------------------------------------------------------------

echo|set/p=Search for cached Visual Studio %group% packages ... 

rem  NOTE: using array instead of list for the %dirs% allows iterating over
rem  dir names with string separators, e.g. commas.

set /a dir_count=0
set dirs=

for /d %%i in (%path_patterns%) do (
  set /a dir_count+=1
  set dirs[!dir_count!]=%%i
)

if %dir_count% NEQ %package_count% (
  echo.
  echo   [ERR] Inconsistent count of package names and related found dirs.
  echo   Probably found several versions.
  goto :END
)

echo OK


rem  -------------------------------------------------------------------------

echo|set/p=Reading first found package version ... 

set VERSION_PATTERN=\d\d\.\d\d\.\d\d\.\d
set get_version=call strmatch "%VERSION_PATTERN%" -txt

rem  Take version of first found package.
for /f %%i in ('%get_version% "%dirs[1]%"') do (
  set version=%%i
)

echo OK

echo|set/p=Check all found packages are of version %version% ... 

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

echo|set/p=Read packages URLs from info files ... 

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

echo|set/p=Writing packages downloader ... 

set outfile=%root%\%group%.%version%.bat

if exist "%outfile%" (
  echo.
  echo   [WARN] Downloader %outfile% will be overwritten.
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
