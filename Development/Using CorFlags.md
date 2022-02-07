# What is CorFlags
The CorFlags Conversion tool allows you to configure the CorFlags section of the header of a portable executable image.

This tool is automatically installed with Visual Studio.

Example:
```
CorFlags.exe "C:\Windows\Microsoft.NET\assembly\GAC_32\PresentationCore\v4.0_4.0.0.0__31bf3856ad364e35\PresentationCore.dll"

Version   : v4.0.30319
CLR Header: 2.5
PE        : PE32
CorFlags  : 0xb
ILONLY    : 1
32BITREQ  : 1
32BITPREF : 0
Signed    : 1
```

Explanation:
```
Version   : Assembly's target framework.
Header    : 2.0/2.5 (Must have version of 2.5 or greater to run natively)
PE        : PE32 (32-bit)/PE32+ (64-bit)
CorFlags  : Hexadecimal value, computed based on below 4 flags.
ILONLY    : 1 if MSIL otherwise 0
32BITREQ  : 1 if 32-bit x86 only assembly otherwise 0
32BITPREF : 1 if 32-bit x86 only preferred in Any CPU architecture otherwise 0
Signed    : 1 if signed with strong name otherwise 0
```

