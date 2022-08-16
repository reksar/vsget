set VSINSTALLDIR=%~dp0

for /f %%i in ('dir /B %VSINSTALLDIR%VC\Tools\MSVC') do (
  set VCToolsVersion=%%i
)

set PATH=%VSINSTALLDIR%VC\Tools\MSVC\%VCToolsVersion%\bin\HostX64\x64;%PATH%
set PATH=%VSINSTALLDIR%MSBuild\Current\Bin\amd64;%PATH%

set Platform=x64
set INCLUDE=%VSINSTALLDIR%VC\Tools\MSVC\%VCToolsVersion%\include
set LIB=%VSINSTALLDIR%VC\Tools\MSVC\%VCToolsVersion%\lib\x64
set LIBPATH=%VSINSTALLDIR%VC\Tools\MSVC\%VCToolsVersion%\lib\x64
