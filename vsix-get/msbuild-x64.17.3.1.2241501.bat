echo Downloading with %~nx0 
echo   Microsoft.Build.vsix 
call download https://download.visualstudio.microsoft.com/download/pr/3ea39897-2215-4613-bb36-0c38d8945b81/9fbf067e1cd794ab6b6af729bbaa44a4b84da160a9643d20af9ae0d55ef38d51/Microsoft.Build.vsix "%~1\Microsoft.Build.vsix" 
echo   b98a3e4.vsix 
call download https://download.visualstudio.microsoft.com/download/pr/6f7fe512-ba3f-4163-9cbe-6e71fe5ab964/b98a3e42449486950f863f617c58fea7643ccf450489ff55cdc6e3aee4c6b86f/payload.vsix "%~1\b98a3e4.vsix" 
echo   fbb74fe.vsix 
call download https://download.visualstudio.microsoft.com/download/pr/6f7fe512-ba3f-4163-9cbe-6e71fe5ab964/fbb74fed51482d8d03e43ce8f167e5be5cd40cbb17b6767eb50c1db6b354c936/payload.vsix "%~1\fbb74fe.vsix" 
echo   e17b4f9.vsix 
call download https://download.visualstudio.microsoft.com/download/pr/6f7fe512-ba3f-4163-9cbe-6e71fe5ab964/e17b4f976def2f24b43d2a13d24f2a3f29a973141d63cb645589fc93b8fbe9c0/payload.vsix "%~1\e17b4f9.vsix" 
echo   c03dd5e.vsix 
call download https://download.visualstudio.microsoft.com/download/pr/6f7fe512-ba3f-4163-9cbe-6e71fe5ab964/c03dd5e000d4dc3ebe2acb79a6258fe1880b915d893b55e2c948126992c5e81f/payload.vsix "%~1\c03dd5e.vsix" 
