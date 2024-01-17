# vsget

Collects portable MS Visual Studio Tools.

Currently only x64-x64 is available for host-target platforms.

```bat
vsget "[destination]"
```

Downloads and unpacks (without installation) to `destination`:

* MS Visual C++ v143 *(~ 500 MB)*

* MS Build v170 *(~ 35 MB)*

* Windows SDK v10.0.22621.755 *(~ 2.4 GB)*

Adds related `vcvars*.bat` to init the VS Tools environment.

## Windows SDK

Windows SDK can be downloaded separately:

```bat
get-sdk "[url]" "[destination]"
```

Downloads the ISO, extracts the MSI installers (with related CAB files) of the
SDK components and unpacks them into `destination`.

The actual `SDK_URL` can be found in `vsget.bat`.

# Uncache MS Visual Studio Components

Use the MS Visual Studio cache to generate `vsix-groups\*.txt` files:

```bat
vsuncache "{CachePath}"
```

If the optional `CachePath` is ommited, tries to find the VS cache path in the
Windows Registry.

# Install Build Tools for Visual Studio

If you don't need exactly a portable version of VS Tools (for example, when you
need to *uncache* VSIX components), you can use `vsinstall` to automatically
install the minimal Visual C++ tools:

* Visual C++ Tools x64

* Windows SDK

Actual versions are set in `URL`, `VC` and `SDK` vars in `vsinstall.bat`:
Build Tools for Visual Studio 2022 (v17);
Windows 10 SDK v20348.
