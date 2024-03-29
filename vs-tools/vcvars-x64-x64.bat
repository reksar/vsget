@echo off

rem  --------------------------------------------------------------------------
rem  Init portable MS Visual Studio env vars.
rem
rem  NOTE: Trailing backslashes in some paths are intended to be compatible
rem  with MSBuild props!
rem  --------------------------------------------------------------------------

set Platform=x64
set HostPlatform=x64
set DisableRegistryUse=true
set "VSINSTALLDIR=%~dp0"
set "VCINSTALLDIR=%VSINSTALLDIR%VC"


rem  --- Detect MSVC version --------------------------------------------------

rem  Find the dir named latest version, e.g. "14.32.31326" for MSVC v143.
for /f %%i in ('dir /b /a:d "%VCINSTALLDIR%\Tools\MSVC\*.*.*"') do (
  set "VCToolsVersion=%%i"
)

if "%VCToolsVersion%" == "" (
  echo [ERR][%~n0] Cant't find any MSVC version.
  exit /b 1
)


rem  --- Detect MSBuild props version for MSVC --------------------------------

rem  Find dir with latest version name, e.g. "v170".
for /f %%i in ('dir /b /a:d "%VSINSTALLDIR%Msbuild\Microsoft\VC\v*"') do (
  set v=%%i
)

if not "%v%" == "" (
  rem  Convert "v170" to "170".
  set v=%v:~1%
) else (
  echo [WARN][%~n0] Can't find any MSBuild props for MSVC.
  goto :SDK
)


rem  When %DisableRegistryUse% is true:
rem  - this env var does not affect MSBuild props
set "VCToolsInstallDir=%VCINSTALLDIR%\Tools\MSVC\%VCToolsVersion%\"
rem  - sets the `VCToolsInstallDir` in MSBuild props
set "VCToolsInstallDir_%v%=%VCToolsInstallDir%"


rem  --- Detect Windows SDK ---------------------------------------------------

:SDK

if not exist "%VSINSTALLDIR%SDK\Windows Kits" (
  echo [WARN][%~n0] Windows SDK not found!
  goto :MAIN_VARS
)

rem  Pick the latest dir in the `Windows Kits`.
for /f %%i in ('dir /b /a:d "%VSINSTALLDIR%SDK\Windows Kits" 2^>NUL') do (
  set "WindowsSDKDir=%VSINSTALLDIR%SDK\Windows Kits\%%i\"
)

rem  Pick the latest common SDK version for Lib and Include.
for /f %%i in ('dir /b /a:d "%WindowsSDKDir%Lib" 2^>NUL') do (
  for /f %%j in ('dir /b /a:d "%WindowsSDKDir%Include" 2^>NUL') do (
    if "%%i" == "%%j" (
      set SDKVersion=%%i
    )
  )
)
if "%SDKVersion%" == "" (
  echo [ERR][%~n0] Unable to detect Windows SDK version!
  goto :MAIN_VARS
)

rem  Check related binaries for %SDKVersion%.
set "SDKBin=%WindowsSDKDir%bin\%SDKVersion%\%Platform%\"
set list_bin=dir /b "%SDKBin%*.exe"
set find_bin=findstr /p /n /e /c:"\.exe"
if exist "%SDKBin%" (
  for /f "tokens=1 delims=:" %%i in ('%list_bin% ^| %find_bin%') do (
    if %%i GTR 0 goto :MAIN_VARS
  )
) else (
  echo [WARN][%~n0] No binaries for Windows SDK %SDKVersion%!
  goto :MAIN_VARS
)
echo [WARN][%~n0] Too few binaries for Windows SDK %SDKVersion%!


rem  --------------------------------------------------------------------------

:MAIN_VARS

set "SDKInclude=%WindowsSDKDir%Include\%SDKVersion%\"
set "WindowsSDK_IncludePath=%SDKInclude%ucrt\"
set "WindowsSDK_IncludePath=%SDKInclude%um\;%WindowsSDK_IncludePath%"
set "WindowsSDK_IncludePath=%SDKInclude%shared\;%WindowsSDK_IncludePath%"

set "SDKLib=%WindowsSDKDir%Lib\%SDKVersion%\"
set "SDKLibs=%SDKLib%um\%Platform%\;%SDKLib%ucrt\%Platform%\"
set "WindowsSDK_LibraryPath_%Platform%=%SDKLibs%"

set "PATH=%VCToolsInstallDir%\bin\Host%HostPlatform%\%Platform%\;%PATH%"
set "PATH=%SDKBin%;%PATH%"

if "%Platform%" == "x64" (
  set MSBuildBin=amd64
)

set "PATH=%VSINSTALLDIR%MSBuild\Current\Bin\%MSBuildBin%;%PATH%"

set "INCLUDE=%VCToolsInstallDir%\include"
set "INCLUDE=%WindowsSDK_IncludePath%;%INCLUDE%"
set "LIBPATH=%VCToolsInstallDir%\lib\%Platform%\"
set "LIB=%VCToolsInstallDir%\lib\%Platform%\;%SDKLibs%"


rem  --- Unset tmp vars -------------------------------------------------------
set v=
set find_bin=
set list_bin=
set MSBuildBin=
set SDKBin=
set SDKInclude=
set SDKLib=
set SDKLibs=
set SDKVersion=
