@echo off

setlocal

set url=%~1
set iso=%~2

if exist "%iso%" (
  echo [WARN][%~n0] Windows SDK ISO already exist!
  exit /b 0
)

echo|set/p=- Downloading Windows SDK ISO ... 
call download "%url%" "%iso%" || (
  echo FAIL
  exit /b 1
)
echo OK

endlocal
