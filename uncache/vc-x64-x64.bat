@echo off
setlocal


rem  --------------------------------------------------------------------------
rem  Using: `vc-x64-x64 [VS CACHE PATH]`.
rem  Creates `..\get\%GROUP%.[version].bat` downloader for %PACKAGES% using
rem  info from MS Visual Studio %cache_path%.

set GROUP=vc-x64-x64

set PACKAGES=^
  "Microsoft.VC.??.??.??.?.CRT.Headers.base" ^
  "Microsoft.VC.??.??.??.?.CRT.Redist.X64.base" ^
  "Microsoft.VC.??.??.??.?.CRT.Source.base" ^
  "Microsoft.VC.??.??.??.?.CRT.x64.Desktop.base" ^
  "Microsoft.VC.??.??.??.?.CRT.x64.Store.base" ^
  "Microsoft.VC.??.??.??.?.Tools.HostX64.TargetX64.base" ^
  "Microsoft.VC.??.??.??.?.Tools.HostX64.TargetX64.Res.base"
rem  -------------------------------------------------------------------------


call "%~dp0uncache" %1 %GROUP% %PACKAGES%
endlocal
