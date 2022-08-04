@echo off
setlocal

rem  Using:
rem    strmatch -txt "[TEXT]" [PATTERN]
rem    strmatch -file [PATH]  [PATTERN]

rem  Must be `-txt` or `-file`.
set arg_name=%1

if "%arg_name%"=="-txt" (
  set input=-InputObject '%~2'
)

if "%arg_name%"=="-file" (
  set input=-Path '%~2'
)

if "%input%"=="" (
  echo [ERR] No -txt or -file is given.
  goto :END
)

rem  Third arg is always the search pattern.
set pattern=%~3

set match=Select-String -Pattern '%pattern%' %input% -AllMatches

rem  The pipe is equivalent to `-Raw` param in powershell v7+
call powershell -command "%match% | %%%% { $_.Matches } | %%%% { $_.Value }"

:END
endlocal
