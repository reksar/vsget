echo Downloading with %~nx0 
echo   Microsoft.Build.vsix 
call download https://download.visualstudio.microsoft.com/download/pr/12645348-9f6f-4d15-b437-b2137b99721c/357c0f4c9be89ebfe3cb1c371c9486efb4ab40ba6e9944ab4ab29bceffa47fee/Microsoft.Build.vsix "%~1\Microsoft.Build.vsix" 
echo   9025f1f.vsix 
call download https://download.visualstudio.microsoft.com/download/pr/b1761a53-f7bb-4cd8-849e-39cb53355f65/9025f1f667d6d4e7bc21f1ea66c51a9942f1ed8f996b479396125cc9dc59146d/payload.vsix "%~1\9025f1f.vsix" 
echo   25d6a66.vsix 
call download https://download.visualstudio.microsoft.com/download/pr/b1761a53-f7bb-4cd8-849e-39cb53355f65/25d6a66780ebd190facb6de0cf672bfad6fb92267b809434e981420374a4477c/payload.vsix "%~1\25d6a66.vsix" 
echo   96ed409.vsix 
call download https://download.visualstudio.microsoft.com/download/pr/b1761a53-f7bb-4cd8-849e-39cb53355f65/96ed4092eeced6a20b1ab626be07103298ea1d3459b20e86e334446ac3d277bb/payload.vsix "%~1\96ed409.vsix" 
echo   fdd2e67.vsix 
call download https://download.visualstudio.microsoft.com/download/pr/b1761a53-f7bb-4cd8-849e-39cb53355f65/fdd2e676ddc82f640d43628f30db31087a54ffb467add970b0bfd815e3b1e375/payload.vsix "%~1\fdd2e67.vsix" 
