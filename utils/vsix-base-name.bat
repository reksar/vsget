@echo off
rem  --------------------------------------------------------------------------
rem  Extracts the VSIX base name from [url] and outputs it to stdout:
rem
rem    vsix-base-name [url]
rem
rem  e.g.
rem
rem    vsix-base-name https://download.visualstudio.microsoft.com/download/pr/
rem      12645348-9f6f-4d15-b437-b2137b99721c/
rem      357c0f4c9be89ebfe3cb1c371c9486efb4ab40ba6e9944ab4ab29bceffa47fee/
rem      Microsoft.Build.vsix
rem
rem  outputs the base name
rem
rem    Microsoft.Build
rem
rem  If the base name is "payload", it will be replaced with a short hash:
rem
rem    vsix-base-name https://download.visualstudio.microsoft.com/download/pr/
rem      b1761a53-f7bb-4cd8-849e-39cb53355f65/
rem      fdd2e676ddc82f640d43628f30db31087a54ffb467add970b0bfd815e3b1e375/
rem      payload.vsix
rem
rem  outputs the hash
rem
rem    3b1e375
rem  --------------------------------------------------------------------------
setlocal
set url=%~1
set url_no_payload=%url:/payload.vsix=%
if %url% == %url_no_payload% (
  rem  Unique VSIX name.
  for %%i in (%url%) do echo %%~ni
) else (
  rem  The default VSIX name is not unique, replace it with a short hash.
  echo %url_no_payload:~-7,7%
)
endlocal
