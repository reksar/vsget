echo Downloading with %~nx0 
echo   Microsoft.VC.14.33.17.3.CRT.Headers.base.vsix 
call download https://download.visualstudio.microsoft.com/download/pr/e6ede711-af5c-48ee-b244-feececdaa95b/49b9016629927ee76d984dad34b810995d1789da6eeb0fd20aa28c5c8dd991f2/Microsoft.VC.14.33.17.3.CRT.Headers.base.vsix "%~1\Microsoft.VC.14.33.17.3.CRT.Headers.base.vsix" 
echo   Microsoft.VC.14.32.17.2.CRT.Redist.X64.base.vsix 
call download https://download.visualstudio.microsoft.com/download/pr/36b944f6-d972-45f7-88da-630fb73ff75b/60cfab9634ea21ea01114174e0655caf07cc6db77dbaf65ae2ed5b3e981b9f8e/Microsoft.VC.14.32.17.2.CRT.Redist.X64.base.vsix "%~1\Microsoft.VC.14.32.17.2.CRT.Redist.X64.base.vsix" 
echo   Microsoft.VC.14.33.17.3.CRT.Source.base.vsix 
call download https://download.visualstudio.microsoft.com/download/pr/e6ede711-af5c-48ee-b244-feececdaa95b/236745b8bd11f88a611ea2ced0caa80d1b45c58889edba6180457675ad9cf5fa/Microsoft.VC.14.33.17.3.CRT.Source.base.vsix "%~1\Microsoft.VC.14.33.17.3.CRT.Source.base.vsix" 
echo   Microsoft.VC.14.33.17.3.CRT.x64.Desktop.base.vsix 
call download https://download.visualstudio.microsoft.com/download/pr/e6ede711-af5c-48ee-b244-feececdaa95b/bd1f1dda22d1f9a742fcae03e54fb1cbd15ea33b113cef64dda7c38146abc178/Microsoft.VC.14.33.17.3.CRT.x64.Desktop.base.vsix "%~1\Microsoft.VC.14.33.17.3.CRT.x64.Desktop.base.vsix" 
echo   Microsoft.VC.14.33.17.3.CRT.x64.Store.base.vsix 
call download https://download.visualstudio.microsoft.com/download/pr/e6ede711-af5c-48ee-b244-feececdaa95b/532c9ab6441bf88f39618a5c3ed5e063a6a76f52d0d4e4822ed88d6cc0f872a5/Microsoft.VC.14.33.17.3.CRT.x64.Store.base.vsix "%~1\Microsoft.VC.14.33.17.3.CRT.x64.Store.base.vsix" 
echo   Microsoft.VC.14.33.17.3.Tools.HostX64.TargetX64.base.vsix 
call download https://download.visualstudio.microsoft.com/download/pr/e6ede711-af5c-48ee-b244-feececdaa95b/a22d3f8db3a0824f982c16b86604b094add42a45241bd977cd255c5abc0baeaa/Microsoft.VC.14.33.17.3.Tools.HostX64.TargetX64.base.vsix "%~1\Microsoft.VC.14.33.17.3.Tools.HostX64.TargetX64.base.vsix" 
echo   Microsoft.VC.14.33.17.3.Tools.HostX64.TargetX64.Res.base.enu.vsix 
call download https://download.visualstudio.microsoft.com/download/pr/e6ede711-af5c-48ee-b244-feececdaa95b/1ed2f1a9766baf3d3393359321d2ba6433bfc30dba1ab11b046462b759ff713d/Microsoft.VC.14.33.17.3.Tools.HostX64.TargetX64.Res.base.enu.vsix "%~1\Microsoft.VC.14.33.17.3.Tools.HostX64.TargetX64.Res.base.enu.vsix" 
