@echo off

rem  --------------------------------------------------------------------------
rem  Using: `vsix-get [DOWNLOADER] [DESTINATION DIR]`.
rem  [DOWNLOADER] must be a file in %root%vsix-get dir and can be provided as:
rem  - %group% name to select latest downloader %version%
rem  - %group%.%version% (file name without ext)
rem  - %group%.%version%.bat (full file name)
rem  - %root%vsix-get\%group%.%version%.bat (full file path)
rem  --------------------------------------------------------------------------

setlocal
set root=%~dp0
set downloaders_dir=%root%vsix-get
set PATH=%root%utils;%PATH%


rem  --- Select downloader ----------------------------------------------------

set downloader_name=%~1

if "%downloader_name%"=="" (
  echo [ERR][%~n0] Downloader is not specified.
  exit /b 1
)

if exist "%downloader_name%" (
  rem  If %downloader_name% is a full file path.
  set downloader=%downloader_name%
) else (
  rem  If %downloader_name% is a full file name.
  for %%i in (%downloaders_dir%\%downloader_name%) do (
    set downloader=%%i
  )
)

if not exist "%downloader%" (
  rem  If %downloader_name% is a file name without ".bat" ext.
  for %%i in (%downloaders_dir%\%downloader_name%.bat) do (
    set downloader=%%i
  )
)

if not exist "%downloader%" (
  rem  If %downloader_name% is only %group% name.
  for %%i in (%downloaders_dir%\%downloader_name%.*.bat) do (
    set downloader=%%i
  )
)

if not exist "%downloader%" (
  echo [ERR][%~n0] Can't find %downloader%
  exit /b 2
)


rem  --- Parse destination ----------------------------------------------------

set destination=%~2

if "%destination%"=="" (
  echo [ERR][%~n0] Destination dir is not specified.
  exit /b 3
)

if not exist "%destination%" (
  echo [ERR][%~n0] Destination is not exists: %destination%
  exit /b 4
)

rem  TODO: check if %destination% is dir


call "%downloader%" "%destination%"
endlocal
