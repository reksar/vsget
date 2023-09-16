@echo off

rem  --------------------------------------------------------------------------
rem  If the `7z` executable (console version of the 7-zip archiver) is not
rem  found, downloads 7-zip to [destination] and adds [destination] to %PATH%.
rem
rem  Using:
rem
rem    ensure-archiver [destination]
rem  --------------------------------------------------------------------------

call which 7z >NUL 2>&1 && exit /b 0

if not exist "%~1\7z.exe" goto :GET_ARCHIVER
if not exist "%~1\7z.dll" goto :GET_ARCHIVER
goto :SET_PATH

:GET_ARCHIVER
echo.
echo Getting 7-zip archiver

setlocal

echo|set/p=- Ensuring destination path exists ... 
call which destination >NUL 2>&1 || set "PATH=%~dp0;%PATH%"
call destination "%~1" || exit /b 1
echo OK

echo|set/p=- Ensuring destination path empty ... 
for %%i in ("%destination%\*") do del /q /s "%%i" >NUL 2>&1
for /d %%i in ("%destination%\*") do rd /q /s "%%i" >NUL 2>&1
echo OK

set "URL_PREFIX=https://www.7-zip.org/a"

rem  Self-extracting 7-zip archive. Unable to extract via command line!
set "ARCHIVE=7z2201-x64.exe"
set "MAIN_URL=%URL_PREFIX%/%ARCHIVE%"

rem  Archiver with limited functionality. Required to extract the main
rem  self-extracting archive via command line.
set "UTIL=7zr.exe"
set "UTIL_URL=%URL_PREFIX%/%UTIL%"

rem  Prevent path encoding errors.
set "origin_path=%CD%"
cd /d "%destination%"

rem  Makes utils available after `cd` when the %origin_path% is %~dp0.
call which download >NUL 2>&1 || set "PATH=%~dp0;%PATH%"

echo|set/p=- Getting 7-zip self-extracting archive ... 
call download "%MAIN_URL%" "%ARCHIVE%" || goto :FAIL
echo OK

echo|set/p=- Getting util archiver ... 
call download "%UTIL_URL%" "%UTIL%" || goto :FAIL
echo OK

echo|set/p=- Extracting 7-zip with util ... 
%UTIL% x -y %ARCHIVE% >NUL || goto :FAIL
echo OK

if not exist "7z.exe" goto :FAIL
if not exist "7z.dll" goto :FAIL
goto :END

:FAIL
cd "%origin_path%"
echo FAIL
exit /b 2

:END
cd "%origin_path%"
echo.
endlocal

:SET_PATH
set "PATH=%~1;%PATH%"
exit /b 0
