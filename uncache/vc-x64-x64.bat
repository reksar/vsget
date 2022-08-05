@echo off

rem  Using:
rem    vc-x64-x64 [VS cache path]

rem  In root dir creates `vc-x64-x64.[VERSION].bat` downloader for %PACKAGES%
rem  based on Visual Studio cache.

setlocal

set GROUP=vc-x64-x64

set PACKAGES=^
  CRT.Headers.base ^
  CRT.Redist.X64.base ^
  CRT.Source.base ^
  CRT.x64.Desktop.base ^
  CRT.x64.Store.base ^
  Tools.HostX64.TargetX64.base ^
  Tools.HostX64.TargetX64.Res.base

set batch_path=%~dp0
set cache_path=%~1

call "%batch_path%\uncache" "%cache_path%" %GROUP% %PACKAGES%

endlocal
