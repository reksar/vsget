@echo off

rem  --------------------------------------------------------------------------
rem  Download Windows SDK from specified [URL] and extract it to [DESTINATION].
rem  Using:
rem
rem    sdk [URL] [DESTINATION] [FEATURES]
rem
rem  [FEATURES] is a list to specify SDK components.
rem  See https://silentinstallhq.com/windows-11-software-development-kit-sdk-silent-install-how-to-guide
rem  - OptionId.AvrfExternal
rem  - OptionId.DesktopCPParm
rem  - OptionId.DesktopCPParm64
rem  - OptionId.DesktopCPPx64
rem  - OptionId.DesktopCPPx86
rem  - OptionId.IpOverUsb
rem  - OptionId.MSIInstallTools
rem  - OptionId.NetFxSoftwareDevelopmentKit
rem  - OptionId.SigningTools
rem  - OptionId.UWPCPP
rem  - OptionId.UWPLocalized
rem  - OptionId.UWPManaged
rem  - OptionId.WindowsDesktopDebuggers
rem  - OptionId.WindowsPerformanceToolkit
rem  - OptionId.WindowsSoftwareLogoToolkit
rem  The "+" means all components.
rem  --------------------------------------------------------------------------


setlocal
set DEFAULT_SDK=OptionId.DesktopCPPx64

rem  Third-party util for extracting *.MSI content without installation.
set LESSMSI_VER=v1.10.0
set LESSMSI_ZIP=lessmsi-%LESSMSI_VER%.zip
set LESSMSI_DOWNLOAD=https://github.com/activescott/lessmsi/releases/download
set LESSMSI_URL=%LESSMSI_DOWNLOAD%/%LESSMSI_VER%/%LESSMSI_ZIP%

set root=%~dp0
set sdk_url=%~1
set destination=%~2
set features=%~3
set "PATH=%root%utils;%PATH%"

if "%destination%" == "" (
  echo [ERR] Destination is not specified.
  exit /b 1
)

if not exist "%destination%" (
  echo [ERR] Destination is not exists: %destination%
  exit /b 2
)

:REMOVE_TRAILING_BACKSLASH
if "%destination:~-1,1%" == "\" (
  set "destination=%destination:~,-1%"
  goto :REMOVE_TRAILING_BACKSLASH
)

set "tmp=%destination%\tmp"

if exist "%tmp%" (
  echo [WARN] Dirty work! Already exists: %tmp%
)


rem  --- Count SDK lib files in %destination% ---------------------------------

set find_lib=findstr /p /n /e /c:"\.lib" /c:"\.h"

set "lib_dir=%destination%\Windows Kits"
set lib_files="%lib_dir%\*.lib" "%lib_dir%\*.h"
set list_lib=dir /b /s %lib_files%

if exist "%lib_dir%" (

  echo [WARN] Already exists: %lib_dir%

  for /f "tokens=1 delims=:" %%i in ('%list_lib% ^| %find_lib%') do (
    if %%i GTR 0 (
      echo [ERR] SDK libs already exists in %destination%
      exit /b 3
    )
  )
)


rem  --- Check SourceDir ------------------------------------------------------

set "SourceDir=%tmp%\SourceDir"

if exist "%SourceDir%" (
  echo [WARN] Already exists: %SourceDir%
)

rem  Reuse vars with the new %lib_dir% value.
set "lib_dir=%SourceDir%\Windows Kits"
set lib_files="%lib_dir%\*.lib" "%lib_dir%\*.h"
set list_lib=dir /b /s %lib_files%

if exist "%SourceDir%\Windows Kits" (
  for /f "tokens=1 delims=:" %%i in ('%list_lib% ^| %find_lib%') do (
    if %%i GTR 0 (
      echo [WARN] SDK libs already exists in %SourceDir%
      goto :MOVE_SDK
    )
  )
)


rem  --- Check SDK installers -------------------------------------------------

set "installers=%tmp%\Installers"
set count_installers=dir /b "%installers%" ^^^| find /c /i

if exist "%installers%" (

  echo [WARN] Already exists: %installers%

  for /f %%i in ('%count_installers% ".msi"') do (
    for /f %%j in ('%count_installers% ".cab"') do (
      if %%i GTR 0 (
        if %%i LEQ %%j (
          echo [WARN] Proceeding with existing SDK installers.
          goto :LESSMSI
        ) else echo [WARN] Suspiciously few CAB files associated with MSI.
      ) else echo [WARN] MSI installers not found.
    )
  )
)


rem  --- Get SDK installers ---------------------------------------------------

set "winsdksetup=%tmp%\winsdksetup.exe"

if not exist "%winsdksetup%" (

  echo|set/p=Downloading Windows SDK installer ... 
  call download "%sdk_url%" "%winsdksetup%"

  if exist "%winsdksetup%" (
    echo OK
  ) else (
    echo FAIL
    exit /b 4
  )
) else echo [WARN] Already exists: %winsdksetup%

rem  Not installation, just downloading SDK components with `/layout`.
echo|set/p=Downloading SDK feature installers ... 

if "%features%" == "" (
  set features=%DEFAULT_SDK%
)

"%winsdksetup%" ^
  /features %features% ^
  /layout "%tmp%" ^
  /log "%tmp%\sdk.log" ^
  /norestart ^
  /quiet ^
  /ceip off

if %ERRORLEVEL% NEQ 0 (
  echo FAIL
  echo [ERR] See %tmp%\sdk.log
  exit /b 5
) else echo OK


rem  --------------------------------------------------------------------------
:LESSMSI

set "lessmsi=%tmp%\lessmsi\lessmsi.exe"

if not exist "%lessmsi%" (

  echo|set/p=Downloading lessmsi ... 
  call download "%LESSMSI_URL%" "%tmp%\%LESSMSI_ZIP%"
  echo OK

  echo|set/p=Unpacking lessmsi ... 
  call unzip "%tmp%\%LESSMSI_ZIP%" "%tmp%\lessmsi"
  echo OK

) else echo [WARN] lessmsi already exists.


rem  --------------------------------------------------------------------------
echo Extracting SDK ...

for %%i in ("%installers%\*.msi") do (
  echo   %%~ni
  rem  A hack to redirect stdout correctly.
  rem  TODO: check the lessmsi issues on GitHub.
  cmd /c "^"%lessmsi%^" x ^"%%i^" ^"%tmp%\^"" > "%tmp%\lessmsi.log"
)

rem  Duplicates can be created during MSI extraction.
del /q /s *.duplicate* >NUL 2>&1


rem  --------------------------------------------------------------------------
:MOVE_SDK

echo Moving SDK files ...

setlocal EnableDelayedExpansion

for /f "delims=" %%i in ('dir /b /s /a:-D "%SourceDir%"') do (

  set file=%%~nxi
  set from_dir=%%~dpi
  set "to_dir=!from_dir:%SourceDir%=%destination%!"

  if not exist "!to_dir!" (
    mkdir "!to_dir!"
  )

  move "!from_dir!!file!" "!to_dir!!file!" >NUL

  if !ERRORLEVEL! NEQ 0 (
    echo   [ERR!ERRORLEVEL!] "!from_dir!!file!" to "!to_dir!!file!"
  )
)
endlocal


rd /q /s "%tmp%"
echo Windows SDK is extracted.
endlocal
