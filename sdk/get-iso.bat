@echo off
setlocal
set url=%~1
set iso=%~2
if not exist "%iso%" (
  echo|set/p=Downloading Windows SDK ISO ... 
  call download "%url%" "%iso%" || (
    echo FAIL
    exit /b 1
  )
  echo OK
) else echo [WARN][%~n0] Windows SDK ISO already exist!
endlocal
