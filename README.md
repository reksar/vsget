# vsget

Collects portable MS Visual Studio tools.

```bat
vsget [DESTINATION]
```

Downloads and unpacks to `[DESTINATION]` path without installation:
* MS Visual C++ v143 *(~ 500 MB)*
* MS Build v170 *(~ 35 MB)*
* Windows SDK v10.0.22621.755 *(~ 2.4 GB)*

Adds related `vcvars*.bat` to init the environment before using the tools.

## Windows SDK

You can download the Windows SDK separately:

```bat
get-sdk [DESTINATION]
```

Downloads the ISO, extracts the MSI installers (with related CAB files) of the
SDK components and unpacks them into `[DESTINATION]`.

# Uncache MS Visual Studio components

**NOTE: it is broken at the moment!**

```bat
uncache-vsix [MSVS CACHE PATH]
```

Uses the MS Visual Studio cache to generate `vsix-groups\*.txt` files.
