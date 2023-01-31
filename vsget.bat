@echo off

rem  --------------------------------------------------------------------------
rem  Downloads and extracts MSVC, MSBuild and Windows SDK to [DESTINATION].
rem
rem  Using:
rem
rem    vsget [DESTINATION]
rem
rem  --------------------------------------------------------------------------

setlocal

rem  MSVC v143
set VC_V=14.33.31629
set VC_GROUP=vc-x64-x64.%VC_V%

rem  MSBuild v170
set MSBUILD_V=17.3.1.2241501
set MSBUILD_GROUP=msbuild-x64.%MSBUILD_V%

rem  Windows SDK v10.0.22621.755
set SDK_URL=https://go.microsoft.com/fwlink/?linkid=2196240

set VCVARS=vcvars-x64-x64

set root=%~dp0
where get-sdk >NUL 2>&1 || set "PATH=%root%;%PATH%"
where destination >NUL 2>&1 || set "PATH=%root%utils;%PATH%"
call destination "%~1" || exit /b 1

copy "%root%tools\%VCVARS%.bat" "%destination%" >NUL
call get-vsix-group %VC_GROUP% "%destination%" || exit /b 2
call get-vsix-group %MSBUILD_GROUP% "%destination%" || exit /b 3
call get-sdk "%SDK_URL%" "%destination%\SDK" || exit /b 4

endlocal
