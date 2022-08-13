@echo off

rem  -------------------------------------------------------------------------
rem  Using: `get [DOWNLOADER] [DESTINATION DIR]`.
rem  A [DOWNLOADER] can be either full file name %group%.%version%.bat or just
rem  %group% to use latest downloader %version%.
rem  -------------------------------------------------------------------------


setlocal
set root=%~dp0
set PATH=%PATH%;%root%utils


rem  --- Select downloader ---------------------------------------------------

set downloader_name=%~1

if "%downloader_name%"=="" (
  echo [ERR] Downloader is not specified.
  goto :END
)

rem  Find a downloader file.
if exist "%downloader_name%" (
  set downloader=%downloader_name%
) else (
  for %%i in (%root%%downloader_name%) do (
    set downloader=%%i
  )
)

rem  Find latest downloader version for specified downloader group.
if not exist "%downloader%" (
  for %%i in (%root%%downloader_name%.*.bat) do (
    set downloader=%%i
  )
)

if not exist "%downloader%" (
  echo [ERR] Can't find a downloader %downloader%
  goto :END
)

echo Using downloader %downloader%


rem  --- Parse destination ---------------------------------------------------

set destination=%~2

if "%destination%"=="" (
  echo [ERR] Destination dir is not specified.
  goto :END
)

if not exist "%destination%" (
  mkdir "%destination%"
)

rem  TODO: check if %destination% is dir


rem  --- Getting packages ----------------------------------------------------

call "%downloader%" "%destination%"


:END
endlocal
