@echo off

rem  --------------------------------------------------------------------------
rem  Installs portable MSVC v143, MSBuild v170 and Windows SDK v10.0.20348.0 to
rem  [DESTINATION] dir passed as the first arg.
rem  --------------------------------------------------------------------------

setlocal

rem  v143
set VC_V=14.32.31326
set VC=vc-x64-x64.%VC_V%

rem  v170
set MSBUILD_V=17.2.1.2225201
set MSBUILD=msbuild-x64.%MSBUILD_V%

rem  v10.0.20348.0
set SDK_URL=https://go.microsoft.com/fwlink/?linkid=2164145
set SDK_FEATURES=OptionId.DesktopCPPx64

set VCVARS_NAME=vcvars-x64-x64

set root=%~dp0
set vcvars=%root%tools\%VCVARS_NAME%.bat
set destination=%~1

if "%destination%"=="" (
  echo [ERR] Destination is not specified.
  goto :END
)

rem  Remove trailing backslashes.
:SANITIZE
if "%destination:~-1,1%"=="\" (
  set destination=%destination:~,-1%
  goto :SANITIZE
)

if not exist "%destination%" (
  md "%destination%"
)

set sdk_destination=%destination%\SDK

if not exist "%sdk_destination%" (
  md "%sdk_destination%"
)

copy "%vcvars%" "%destination%" >NUL
call vsix-get %VC% "%destination%" || goto :END
call vsix-get %MSBUILD% "%destination%" || goto :END
call vsix-unpack "%destination%" || goto :END
call sdk "%SDK_URL%" "%sdk_destination%" "%SDK_FEATURES%" || goto :END

:END
endlocal
