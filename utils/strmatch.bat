@echo off

rem  --------------------------------------------------------------------------
rem  https://gist.github.com/reksar/c8065f83cb0f98f1d3175a77f517f0e6
rem  Using:
rem    strmatch [pattern] -txt "[text]"
rem    strmatch [pattern] -file [path]
rem  --------------------------------------------------------------------------

setlocal

set pattern=%~1
set input_type=%2
set target=%~3

if "%pattern%" == "" (
  echo [ERR][%~n0] Search pattern is not set.
  goto :END
)

if "%input_type%" == "" (
  echo [ERR][%~n0] Input type is not set.
  goto :END
)

if not %input_type% == -txt (
  if not %input_type% == -file (
    echo [ERR][%~n0] Input type must be either `-txt` or `-file`.
    goto :END
  )
)

if "%target%" == "" (
  echo [ERR][%~n0] No string to search in.
  goto :END
)

if %input_type% == -txt (
  set input=-InputObject '%target%'
)

if %input_type% == -file (
  set input=-Path '%target%'
)

set match=Select-String -Pattern '%pattern%' -AllMatches %input%

rem  The pipe is equivalent to `-Raw` param in powershell v7+
call powershell -command "%match% | %%%% { $_.Matches } | %%%% { $_.Value }"

:END
endlocal
