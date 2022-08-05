@echo off
rem  https://gist.github.com/reksar/580abdfe92c6064181befd55c1ffb6ce
setlocal
set url=%~1
set outfile=%~2
call powershell -command ^
  "Invoke-WebRequest -UseBasicParsing -Uri '%url%' -OutFile '%outfile%'"
endlocal
