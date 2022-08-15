@echo off
setlocal


rem  --------------------------------------------------------------------------
rem  Using: `msbuild [VS CACHE PATH]`.
rem  Creates `..\get\%GROUP%.[version].bat` downloader for %PACKAGES% using
rem  info from MS Visual Studio %cache_path%.

set GROUP=msbuild

set PACKAGES=^
  "Microsoft.Build,version="
rem  --------------------------------------------------------------------------


call "%~dp0uncache" %1 %GROUP% %PACKAGES%
endlocal
