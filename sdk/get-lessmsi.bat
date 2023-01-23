@echo off

rem  --------------------------------------------------------------------------
rem  Third-party util for extracting *.MSI content without its installation.
rem
rem  Using:
rem
rem    get-lessmsi [DESTINATION]
rem
rem  Requires `utils`.
rem  --------------------------------------------------------------------------

setlocal
set LESSMSI_VER=v1.10.0
set LESSMSI_ZIP=lessmsi-%LESSMSI_VER%.zip
set LESSMSI_DOWNLOAD=https://github.com/activescott/lessmsi/releases/download
set LESSMSI_URL=%LESSMSI_DOWNLOAD%/%LESSMSI_VER%/%LESSMSI_ZIP%

rem  Abs path expected!
set destination=%~1
set "lessmsi=%destination%\lessmsi.exe"

if not exist "%lessmsi%" (

  if not exist "%destination%" (
    md "%destination%"
  ) else echo [WARN][%~n0] Already exist: %destination%

  echo|set/p=Downloading lessmsi ... 
  call download "%LESSMSI_URL%" "%destination%\%LESSMSI_ZIP%" || (
    echo FAIL
    exit /b 1
  )
  echo OK

  echo|set/p=Unpacking lessmsi ... 
  call unzip "%destination%\%LESSMSI_ZIP%" "%destination%" || (
    echo FAIL
    exit /b 2
  )
  echo OK

) else echo [WARN][%~n0] Already exist!
endlocal
