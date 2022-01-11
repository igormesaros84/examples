# Install wsl
> To update to WSL 2, you must be running Windows 10.
>
>For x64 systems: Version 1903 or higher, with Build 18362 or higher.
For ARM64 systems: Version 2004 or higher, with Build 19041 or higher.
Builds lower than 18362 do not support WSL 2. Use the Windows Update Assistant to update your version of Windows.


You must first enable the "Windows Subsystem for Linux" optional feature before installing any Linux distributions on Windows.

```
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
```

Before installing WSL 2, you must enable the Virtual Machine Platform optional feature. Your machine will require virtualization capabilities to use this feature.

```
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

Download the latest package, WSL2 Linux kernel update package for x64 machines

```
 Invoke-WebRequest -Uri https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -OutFile wsl-update-x64.msi -UseBasicParsing
 ```

 # Install Ubuntu

 Download Ubuntu 20.04 LTS appx
```
Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 -OutFile Ubuntu.appx -UseBasicParsing
```

  and install it
```
Add-AppxPackage .\Ubuntu.appx
```
