# Get Visual Studio packages

`get [DOWNLOADER] [DESTINATION DIR]`

A `[DOWNLOADER]` can be either full file name `<group>.<version>.bat` or just 
packages `<group>` name to use latest `<version>` of downloader.

This will download `*.vsix` packages to `[DESTINATION DIR]`.

**Examples:**
```bat
get vc-x64-x64 <destination>
get msbuild <destination>
get msbuild.17.2.1.2225201 <destination>
get msbuild.17.2.1.2225201.bat <destination>
get <abspath>\get\msbuild.17.2.1.2225201.bat <destination>
```

# Unpack

`unpack <destination>`

Unpack `Contents` of each downloaded `*.vsix` package to `<destination>`.

# Uncache

`uncache\[GROUP] [MSVS CACHE PATH]`

Create `get\[GROUP].<version>.bat` downloader for spicefied packages `[GROUP]` 
from specified Visual Studio `[CACHE PATH]`.

**Examples:**
```bat
uncache\vc-x64-x64 <cache path>
uncache\msbuild <cache path>
```
