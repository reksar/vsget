@echo off
setlocal
rem  https://gist.github.com/reksar/c8065f83cb0f98f1d3175a77f517f0e6

rem  Using:
rem    strmatch [PATTERN] -txt "[TEXT]"
rem    strmatch [PATTERN] -file [PATH]

rem  First arg must be a search pattern.
set pattern=%~1

if "%pattern%"=="" (
  echo [ERR] Search pattern is not set.
  goto :END
)

rem  Second arg must be either `-txt` or `-file`.
set input_type=%2

if "%input_type%"=="" (
  echo [ERR] Input type is not set.
  goto :END
)

if not "%input_type%"=="-txt" (
  if not "%input_type%"=="-file" (
    echo [ERR] Input type must be either `-txt` or `-file`.
    goto :END
  )
)

rem  Third arg is a value to search in.

if "%~3"=="" (
  echo [ERR] No value to search in.
  goto :END
)

if "%input_type%"=="-txt" (
  set input=-InputObject '%~3'
)

if "%input_type%"=="-file" (
  set input=-Path '%~3'
)

set match=Select-String -Pattern '%pattern%' -AllMatches %input%

rem  The pipe is equivalent to `-Raw` param in powershell v7+
call powershell -command "%match% | %%%% { $_.Matches } | %%%% { $_.Value }"

:END
endlocal
