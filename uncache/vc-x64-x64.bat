@echo off
setlocal EnableDelayedExpansion

rem  -------------------------------------------------------------------------
rem  Using: `vc-x64-x64 [VS CACHE PATH]`.
rem  In root dir creates `%GROUP%.[VERSION].bat` downloader for %PACKAGES%
rem  based on its %path_patterns% in the Visual Studio cache.

set GROUP=vc-x64-x64

set PREFIX=Microsoft.VC.??.??.??.?.

set PACKAGES=^
  CRT.Headers.base ^
  CRT.Redist.X64.base ^
  CRT.Source.base ^
  CRT.x64.Desktop.base ^
  CRT.x64.Store.base ^
  Tools.HostX64.TargetX64.base ^
  Tools.HostX64.TargetX64.Res.base

rem  -------------------------------------------------------------------------


set cache_path=%~1

if "%cache_path%"=="" (
  echo [ERR] Visual Studio cache path is not given.
  goto :END
)

if not exist "%cache_path%" (
  echo [ERR] Visual Studio cache path is not exists.
  goto :END
)


set path_patterns=

for %%i in (%PACKAGES%) do (
  set path_patterns=!path_patterns! "%cache_path%\%PREFIX%%%i*"
)


set batch_dir=%~dp0
call "%batch_dir%uncache" %GROUP% %path_patterns%


:END
endlocal
