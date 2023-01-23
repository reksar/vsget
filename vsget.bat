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
set VC=vc-x64-x64.%VC_V%

rem  MSBuild v170
set MSBUILD_V=17.3.1.2241501
set MSBUILD=msbuild-x64.%MSBUILD_V%

rem  Windows SDK v10.0.22621.755
set SDK_URL=https://go.microsoft.com/fwlink/?linkid=2196240

set VCVARS_NAME=vcvars-x64-x64


set root=%~dp0
set destination=%~1

set "vcvars=%root%tools\%VCVARS_NAME%.bat"
set "vc_downloader=%root%vsix-downloaders\%VC%.bat"
set "msbuild_downloader=%root%vsix-downloaders\%MSBUILD%.bat"
set "sdk_downloader=%root%get-sdk.bat"


if "%destination%" == "" (
  echo [ERR][%~n0] Destination is not specified.
  goto :END
)

:REMOVE_TRAILING_BACKSLASH
if "%destination:~-1,1%" == "\" (
  set "destination=%destination:~,-1%"
  goto :REMOVE_TRAILING_BACKSLASH
)

if not exist "%destination%" (
  md "%destination%"
) else echo [WARN][%~n0] Already exist: %destination%

call "%vc_downloader%" "%destination%" || exit /b 1
call "%msbuild_downloader%" "%destination%" || exit /b 2
call "%root%unpack-vsix" "%destination%" || exit /b 3
copy "%vcvars%" "%destination%" >NUL
call "%sdk_downloader%" "%SDK_URL%" "%destination%\SDK" || exit /b 4
endlocal
