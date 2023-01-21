@echo off

rem  --------------------------------------------------------------------------
rem  Downloads portable MSVC, MSBuild and Windows SDK to destination, specified
rem  as the first arg.
rem  --------------------------------------------------------------------------


setlocal

rem  MSVC v143
set VC_V=14.33.31629
set VC=vc-x64-x64.%VC_V%

rem  MSBuild v170
set MSBUILD_V=17.3.1.2241501
set MSBUILD=msbuild-x64.%MSBUILD_V%

rem  Windows SDK v10.0.22621.755
set SDK_URL=https://go.microsoft.com/fwlink/?linkid=2196241
set SDK_FEATURES=OptionId.DesktopCPPx64

set VCVARS_NAME=vcvars-x64-x64

set root=%~dp0
set destination=%~1
set "vcvars=%root%tools\%VCVARS_NAME%.bat"

if "%destination%" == "" (
  echo [ERR] Destination is not specified.
  goto :END
)

:REMOVE_TRAILING_BACKSLASH
if "%destination:~-1,1%" == "\" (
  set "destination=%destination:~,-1%"
  goto :REMOVE_TRAILING_BACKSLASH
)

if not exist "%destination%" (
  md "%destination%"
)

set "sdk_destination=%destination%\SDK"

if not exist "%sdk_destination%" (
  md "%sdk_destination%"
)

call "%root%sdk" "%SDK_URL%" "%sdk_destination%" "%SDK_FEATURES%" || goto :END
call "%root%vsix-get" %VC% "%destination%" || goto :END
call "%root%vsix-get" %MSBUILD% "%destination%" || goto :END
call "%root%vsix-unpack" "%destination%" || goto :END
copy "%vcvars%" "%destination%" >NUL

:END
endlocal
