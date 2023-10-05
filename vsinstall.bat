@echo off

rem  --------------------------------------------------------------------------
rem  Installs minimal MS Visual Studio tools:
rem    * Visual C++ Tools x64
rem    * Windows SDK
rem
rem  See help using `vs_BuildTools.exe -h`.
rem  See https://docs.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-build-tools?view=vs-2022
rem  --------------------------------------------------------------------------

setlocal

set EXE=vs_BuildTools.exe
set URL=https://aka.ms/vs/17/release/%EXE%
set VC=Microsoft.VisualStudio.Component.VC.Tools.x86.x64
set SDK=Microsoft.VisualStudio.Component.Windows10SDK.20348

set AGENT="Mozilla/4.0 (compatible; Win32; WinHttp.WinHttpRequest.5)"
set "installer=%TEMP%\%EXE%"

call which download >NUL 2>&1 || set "PATH=%PATH%;%~dp0utils"

call download "%URL%" "%installer%" || (
  echo Unable to download Visual Studio Tools installer!
  goto :EOF
)

"%installer%" --passive --add %VC% --add %SDK%

del "%installer%"

endlocal
