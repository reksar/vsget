@echo off
setlocal EnableDelayedExpansion

rem  -------------------------------------------------------------------------
rem  Using: `msbuild [VS CACHE PATH]`.
rem  In root dir creates `%GROUP%.[VERSION].bat` downloader for %PACKAGES%
rem  based on its %path_patterns% in the Visual Studio cache.

set GROUP=msbuild

set PACKAGES=^
  Microsoft.Build

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
  set path_patterns=!path_patterns! "%cache_path%\%%i,version=*"
)


set batch_dir=%~dp0
call "%batch_dir%uncache" %GROUP% %path_patterns%


:END
endlocal
