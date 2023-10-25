@echo off

rem  --------------------------------------------------------------------------
rem  Downloads the VSIX package of a MSVC component, extracts the `Contents` to
rem  [destination].
rem
rem  Using:
rem
rem    get-vsix [VSIX URL] [destination]
rem
rem  --------------------------------------------------------------------------

setlocal

call which destination >NUL 2>&1 || set "PATH=%~dp0utils;%PATH%"

set url=%~1
call destination "%~2" || exit /b 1

set "tmp=%destination%\tmp"

for /f %%i in ('call vsix-base-name "%url%"') do set vsix_name=%%i

echo - Getting %vsix_name%

set "vsix=%tmp%\vsix"
if not exist "%vsix%" md "%vsix%"

set "vsix_zip=%vsix%\%vsix_name%.zip"

if not exist "%vsix_zip%" (
  echo|set/p=-   Downloading ... 
  call download "%url%" "%vsix_zip%" || (
    echo FAIL
    exit /b 4
  )
  echo OK
) else echo -   [WARN] %vsix_name%.zip already exist!

set "extracted=%vsix%\extracted"
if not exist "%extracted%" md "%extracted%"

echo|set/p=-   Extracting ... 
call unzip "%vsix_zip%" "%extracted%" || (
  echo FAIL
  exit /b 6
)
echo OK

robocopy "%extracted%\Contents" "%destination%" * ^
  /S /MOV /NFL /NDL /NJH /NJS >NUL

rd /s /q "%extracted%" >NUL 2>&1
del "%vsix_zip%" >NUL 2>&1

for %%i in ("%vsix%\*") do goto :SKIP_RD_VSIX
rd /s /q "%vsix%" >NUL 2>&1
:SKIP_RD_VSIX

for %%i in ("%tmp%\*") do goto :SKIP_RD_TMP
for /d %%i in ("%tmp%\*") do goto :SKIP_RD_TMP
rd /s /q "%tmp%" >NUL 2>&1
:SKIP_RD_TMP

endlocal
