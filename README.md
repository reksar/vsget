## Get VS packages

Download MSVC x64-x64 VSIX packages to destination dir:
```bat
vc-x64-x64 [DESTINATION]
```
or
```bat
vc-x64-x64 [DESTINATION] [DOWNLOADER]
```

`[DOWNLOADER]` must be a filename `vc-x64-x64.[VERSION].bat`. 
If it is not provided, the latest version of the downloader will be used.

## Uncache

Create `vc-x64-x64.[VERSION].bat` based on cached packages info:
```bat
uncache\vc-x64-x64 [MSVS CACHE PATH]
```
