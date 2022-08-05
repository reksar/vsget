@echo off
rem  https://gist.github.com/reksar/f6112cf70d979fd7570eec04def4bb28
setlocal
set zip=%~1
set destination=%~2
rem  Requires powershell v5+
call powershell -command ^
  "Expand-Archive '%zip%' -DestinationPath '%destination%'"
endlocal
