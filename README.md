# vsget

Collects portable MS Visual Studio tools.

Currently only x64-x64 is available for host-target platforms.

```bat
vsget [destination]
```

- Downloads and unpacks (without installation) to `[destination]` path:
  * MS Visual C++ v143 *(~ 500 MB)*
  * MS Build v170 *(~ 35 MB)*
  * Windows SDK v10.0.22621.755 *(~ 2.4 GB)*
- Adds related `vcvars*.bat` to init the environment before using the tools.

## Windows SDK

Windows SDK can be downloaded separately:

```bat
get-sdk [destination]
```

Downloads the ISO, extracts the MSI installers (with related CAB files) of the
SDK components and unpacks them into `[destination]`.

# Uncache MS Visual Studio components

**NOTE: it is broken at the moment!**

```bat
uncache-vsix [MSVS CACHE PATH]
```

Uses the MS Visual Studio cache to generate `vsix-groups\*.txt` files.

# Install Build Tools for Visual Studio

If you don't need exactly a portable version of VS Tools (for example, when you
need to *uncache* VSIX components), you can use `vsinstall` to automatically
install the minimal Visual C++ tools:

* Visual C++ Tools x64

* Windows SDK

Actual versions are set in `URL`, `VC` and `SDK` vars in `vsinstall.bat`:
Build Tools for Visual Studio 2022 (v17);
Windows 10 SDK v20348.
