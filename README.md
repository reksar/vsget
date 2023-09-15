# vsget

Collects portable MS Visual Studio tools.

NOTE: currently only x64-x64 are available for host-target platforms.

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
