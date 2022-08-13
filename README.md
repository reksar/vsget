# Get Visual Studio packages

`get [DOWNLOADER] [DESTINATION DIR]`

A `[DOWNLOADER]` can be either full file name `<group>.<version>.bat` or just 
packages `<group>` name to use latest downloader `<version>`.

This will download `*.vsix` packages to `[DESTINATION DIR]`.

**Examples:**
```bat
get vc-x64-x64 <destination>
get msbuild <destination>
get msbuild.17.2.1.2225201.bat <destination>
```

# Uncache

`uncache\[GROUP] [MSVS CACHE PATH]`

Create `<group>.<version>.bat` downloader for spicefied packages `<group>` 
from Visual Studio cache.

**Examples:**
```bat
uncache\vc-x64-x64 <cache path>
uncache\msbuild <cache path>
```
