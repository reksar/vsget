# vsget

Download MS Visual C++, MS Build and Windows SDK.

**MSVC v143, MSBuild C++ v170, Windows SDK v10.0.20348.0 (x64 -> x64)**

`vc-x64-x64.143.170.20348 <destination>`

## Note

Init the related `<destination>\vcvars*.bat` before using downloaded MS Visual
Studio tools.

## Get VSIX package

`get [DOWNLOADER] [DESTINATION DIR]`

A `[DOWNLOADER]` can be either full file name `<group>.<version>.bat` or just 
packages `<group>` name to use latest `<version>` of downloader.

This will download `*.vsix` packages to `[DESTINATION DIR]`.

**Examples:**
```bat
get vc-x64-x64 <destination>
get msbuild-x64 <destination>
get msbuild-x64.17.2.1.2225201 <destination>
get msbuild-x64.17.2.1.2225201.bat <destination>
get <abspath>\get\msbuild-x64.17.2.1.2225201.bat <destination>
```

# Unpack VSIX packages

`unpack <destination>`

Unpack `Contents` of each downloaded `*.vsix` package to `<destination>`.

# Uncache MS Visual Studio component groups

Uncache all: `uncache [MSVS CACHE PATH]`

Uncache specified packages group: `uncache\[GROUP] [MSVS CACHE PATH]`

Uncaching creates `get\[GROUP].<version>.bat` downloaders for spicefied 
packages `[GROUP]` from specified `[MSVS CACHE PATH]`.

**Examples:**
```bat
uncache <cache path>
uncache\vc-x64-x64 <cache path>
uncache\msbuild-x64 <cache path>
```
