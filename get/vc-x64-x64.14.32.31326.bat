echo Downloading with %~nx0 
echo   Microsoft.VC.14.32.17.2.CRT.Headers.base.vsix 
call download https://download.visualstudio.microsoft.com/download/pr/8ebcd306-6d9d-429c-9eea-fbd587f67209/844006c8aecf9c39d447477c97ccbb5900cc1b0bac4a31367b1ad00164d455c0/Microsoft.VC.14.32.17.2.CRT.Headers.base.vsix "%~1\Microsoft.VC.14.32.17.2.CRT.Headers.base.vsix" 
echo   Microsoft.VC.14.32.17.2.CRT.Redist.X64.base.vsix 
call download https://download.visualstudio.microsoft.com/download/pr/36b944f6-d972-45f7-88da-630fb73ff75b/60cfab9634ea21ea01114174e0655caf07cc6db77dbaf65ae2ed5b3e981b9f8e/Microsoft.VC.14.32.17.2.CRT.Redist.X64.base.vsix "%~1\Microsoft.VC.14.32.17.2.CRT.Redist.X64.base.vsix" 
echo   Microsoft.VC.14.32.17.2.CRT.Source.base.vsix 
call download https://download.visualstudio.microsoft.com/download/pr/36b944f6-d972-45f7-88da-630fb73ff75b/f0c7f4ff98246c5a861c3b2ceb264cfab402c1400994b3b900c621f2b809aec5/Microsoft.VC.14.32.17.2.CRT.Source.base.vsix "%~1\Microsoft.VC.14.32.17.2.CRT.Source.base.vsix" 
echo   Microsoft.VC.14.32.17.2.CRT.x64.Desktop.base.vsix 
call download https://download.visualstudio.microsoft.com/download/pr/36b944f6-d972-45f7-88da-630fb73ff75b/134a1e015d580b0276791a3ca2a14c1c26ee5046919a4018d53cb9219ec49186/Microsoft.VC.14.32.17.2.CRT.x64.Desktop.base.vsix "%~1\Microsoft.VC.14.32.17.2.CRT.x64.Desktop.base.vsix" 
echo   Microsoft.VC.14.32.17.2.CRT.x64.Store.base.vsix 
call download https://download.visualstudio.microsoft.com/download/pr/36b944f6-d972-45f7-88da-630fb73ff75b/843c023a9f6ef0fb6ae648f6d94205b7390dbe30c74a84d605266714ed139b5c/Microsoft.VC.14.32.17.2.CRT.x64.Store.base.vsix "%~1\Microsoft.VC.14.32.17.2.CRT.x64.Store.base.vsix" 
echo   Microsoft.VC.14.32.17.2.Tools.HostX64.TargetX64.base.vsix 
call download https://download.visualstudio.microsoft.com/download/pr/36b944f6-d972-45f7-88da-630fb73ff75b/d3761111bf1f393ef238b5f6064491cd92a298b7db3a298d789a00cb9c871d50/Microsoft.VC.14.32.17.2.Tools.HostX64.TargetX64.base.vsix "%~1\Microsoft.VC.14.32.17.2.Tools.HostX64.TargetX64.base.vsix" 
echo   Microsoft.VC.14.32.17.2.Tools.HostX64.TargetX64.Res.base.enu.vsix 
call download https://download.visualstudio.microsoft.com/download/pr/36b944f6-d972-45f7-88da-630fb73ff75b/e40442fbb43f278bd772b4f21120cc319ba950eaf6e33472f6ddce642e655da9/Microsoft.VC.14.32.17.2.Tools.HostX64.TargetX64.Res.base.enu.vsix "%~1\Microsoft.VC.14.32.17.2.Tools.HostX64.TargetX64.Res.base.enu.vsix" 
