@echo off

rem  --------------------------------------------------------------------------
rem  Using: `uncache [VS CACHE PATH] [GROUP] [PACKAGES ...]`.
rem  Creates `%root%\get\%group%.%version%.bat` downloader for given %packages%
rem  list from the Visual Studio %cache_path%. A %group% name can be arbitrary.
rem  --------------------------------------------------------------------------


setlocal EnableDelayedExpansion
set root=%~dp0..
set PATH=%PATH%;%root%\utils


rem  --- Parse args -----------------------------------------------------------

set cache_path=%~1

if "%cache_path%"=="" (
  echo [ERR] Visual Studio cache path is not set.
  goto :END
)

if not exist "%cache_path%" (
  echo [ERR] Visual Studio cache path is not exists.
  goto :END
)

shift

set group=%~1

if "%group%"=="" (
  echo [ERR] Packages group is not set.
  goto :END
)

rem  All remaining args are cached VS packages.
rem  NOTE: using an array instead of a list for allows iterating over paths
rem  containing separators such as spaces and commas.

set /a package_count=0
set packages=
:PACKAGES
shift
if not "%~1"=="" (
  set /a package_count+=1
  set packages[!package_count!]=%~1
  goto :PACKAGES
)

if %package_count% EQU 0 (
  echo [ERR] Can't count given Visual Studio packages path patterns.
  goto :END
)


rem  --- Build path patterns to search packages dirs in VS cache --------------

echo Creating downloader for %group%:

for /l %%i in (1,1,%package_count%) do (
  echo   !packages[%%i]!
  set path_patterns[%%i]=%cache_path%\!packages[%%i]!*
)


rem  --------------------------------------------------------------------------

echo|set/p=Searching for cached %group% packages ... 

set /a dir_count=0
set dirs=

for /l %%i in (1,1,%package_count%) do (
  for /d %%j in ("!path_patterns[%%i]!") do (
    set /a dir_count+=1
    set dirs[!dir_count!]=%%j
  )
)

if %dir_count% NEQ %package_count% (
  echo.
  echo   [ERR] Inconsistent count of package patterns and matched dirs.
  echo   Probably some packages were not found or several versions were found.
  goto :END
)

echo OK


rem  --------------------------------------------------------------------------

echo|set/p=Reading first matched package version ... 

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


rem  --------------------------------------------------------------------------

echo|set/p=Checking whole packages group is of version %version% ... 

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


rem  --------------------------------------------------------------------------

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


rem  --- Create batch downloader ----------------------------------------------

echo|set/p=Writing downloader %group%.%version%.bat ... 

set outfile=%root%\get\%group%.%version%.bat

if exist "%outfile%" (
  echo.
  echo   [WARN] overwritting the %outfile%
  del "%outfile%"
)

echo echo Downloading with %%~nx0 >> "%outfile%"

rem  VSIX URL suffix.
set VSIX_FILE_PATTERN=[.\w\d]+$
set get_vsix_name=call strmatch "%VSIX_FILE_PATTERN%" -txt

set HASH_PATTERN=/[\w\d]+/
set get_vsix_hash=call strmatch "%HASH_PATTERN%" -txt

for %%i in (%urls%) do (
  for /f %%j in ('%get_vsix_name% "%%i"') do (

    if /i "%%j"=="payload.vsix" (
      rem  Use hash instead of default name.
      for /f %%k in ('%get_vsix_hash% "%%i"') do (
        set hash=%%k
        set vsix_name=!hash:~1,7!.vsix
      )
    ) else (
      rem  Assuming the name is unique.
      set vsix_name=%%j
    )

    echo echo   !vsix_name! >> "%outfile%"
    echo call download %%i "%%~1\!vsix_name!" >> "%outfile%"
  )
)

echo DONE


:END
endlocal
