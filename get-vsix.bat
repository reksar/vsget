@echo off

rem  --------------------------------------------------------------------------
rem  Downloads the VSIX package of a MSVC component, extracts the `Contents` to
rem  [DESTINATION].
rem
rem  Using:
rem
rem    get-vsix [VSIX URL] [DESTINATION]
rem
rem  --------------------------------------------------------------------------

setlocal

set url=%~1

where destination >NUL 2>&1 || set "PATH=%~dp0utils;%PATH%"

call destination "%~2" || exit /b 1
set "destination_dir=%destination%"

call destination "%destination_dir%\tmp" || exit /b 2
set "tmp_dir=%destination%"

call destination "%tmp_dir%\vsix" || exit /b 3
set "vsix_dir=%destination%"

for /f %%i in ('call vsix-base-name "%url%"') do (
  set vsix_name=%%i
)

echo - Getting %vsix_name%

set "vsix=%vsix_dir%\%vsix_name%.zip"

if not exist "%vsix%" (
  echo|set/p=--- Downloading ...
  call download "%url%" "%vsix%" || (
    echo FAIL
    exit /b 4
  )
  echo OK
) else echo --- [WARN] %vsix_name%.zip already exist!

call destination "%vsix_dir%\extracted" || exit /b 5
set "extracted_dir=%destination%"

where 7z >NUL 2>&1 || (
  echo|set/p=--- Extracting with deprecated `unzip` ... 
  call unzip "%vsix%" "%extracted_dir%" || (
    echo FAIL
    exit /b 6
  )
  echo OK
  goto :MOVE_CONTENTS
)

echo|set/p=--- Extracting ... 
7z x -y -o"%extracted_dir%" "%vsix%" || (
  echo FAIL
  exit /b 6
)
echo OK

:MOVE_CONTENTS
robocopy "%extracted_dir%\Contents" "%destination_dir%" * ^
  /S /MOV /NFL /NDL /NJH /NJS >NUL
rd /s /q "%extracted_dir%"
del "%vsix%"

for %%i in ("%vsix_dir%\*") do goto :SKIP_RD_VSIX
rd /s /q "%vsix_dir%"
:SKIP_RD_VSIX

for %%i in ("%tmp_dir%\*") do goto :SKIP_RD_TMP
for /d %%i in ("%tmp_dir%\*") do goto :SKIP_RD_TMP
rd /s /q "%tmp_dir%"
:SKIP_RD_TMP

endlocal
