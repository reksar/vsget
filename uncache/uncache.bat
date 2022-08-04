@echo off

rem  Using:
rem    uncache [VS cache path] [packages group] [package names ...]

rem  Creates %root%\%group%.%version%.bat downloader for given %packages%
rem  based on Visual Studio cache from given %cache_path%.

setlocal EnableDelayedExpansion
set root=%~dp0\..
set PATH=%PATH%;%root%


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


rem  --- List package dir path patterns --------------------------------------

set /a package_count=0
set path_patterns=

for %%i in (%packages%) do (
  set /a package_count+=1
  set path_patterns=!path_patterns! %cache_path%\Microsoft.VC.*.%%i*
)

if %package_count% EQU 0 (
  echo [ERR] Can't count given Visual Studio package names.
  goto :END
)


rem  --- List package dirs ---------------------------------------------------

rem  NOTE: use array instead of list to store dir names, because its names 
rem  contains bad delimiters that complicate looping through.

set /a dir_count=0
set dirs=

for /d %%i in (%path_patterns%) do (
  set /a dir_count+=1
  set dirs[!dir_count!]=%%i
)

if %dir_count% NEQ %package_count% (
  echo [ERR] Inconsistent count of package names and related found dirs.
  echo Probably found several versions.
  goto :END
)


rem  --- Check versions ------------------------------------------------------

set VERSION_PATTERN=\d\d\.\d\d\.\d\d\.\d
set get_version=call strmatch -txt "%dirs[1]%" "%VERSION_PATTERN%"

for /f %%i in ('%get_version%') do (
  set version=%%i
)

rem  Compare next packages versions with first version.
for /l %%i in (2,1,%dir_count%) do (

  set next_dir=!dirs[%%i]!
  set get_next_version=call strmatch -txt "!next_dir!" "%VERSION_PATTERN%"

  for /f %%j in ('!get_next_version!') do (
    if not "%%j"=="%version%" (
      echo [ERR] Inconsistent packages versions.
      goto :END
    )
  )
)


rem  --- List package URLs ---------------------------------------------------

rem  Each `_package.json` is expected to contain exacly one URL matching this
set VSIX_URL_PATTERN=https:\/\/.*\.vsix

set urls=

for /l %%i in (1,1,%dir_count%) do (

  set info_file=!dirs[%%i]!\_package.json

  if not exist "!info_file!" (
    echo [ERR] Not exists: !file!
    goto :END
  )

  set find_url=call strmatch -file "!info_file!" "%VSIX_URL_PATTERN%"

  for /f %%j in ('!find_url!') do (
    set urls=!urls! %%j
  )
)


rem  --- Create batch downloader ---------------------------------------------

set outfile=%root%\%group%.%version%.bat

if exist "%outfile%" (
  echo [WARN] Downloader for %group% v%version% will be overwritten.
  del "%outfile%"
)

rem  VSIX URL suffix.
set VSIX_FILE_PATTERN=[.\w\d]+$

for %%i in (%urls%) do (

  set get_vsix_name=call strmatch -txt "%%i" "%VSIX_FILE_PATTERN%"

  for /f %%j in ('!get_vsix_name!') do (
    echo call download %%i "%%~1\%%j" >> "%outfile%"
  )
)


:END
endlocal
