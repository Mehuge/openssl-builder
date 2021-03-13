Windows Overview
==
Scripts that will take much of the hard work out of building openssl on windows.

These scripts are designed to work with version openssl v1.1 and later.

Prequisits
==

The windows build requires a number of tools some of which must already be installed.

Visual Studio
--
The windows build scripts supports [Visual Studio](https://visualstudio.microsoft.com/downloads/) 11, 12, 14, 2017 and 2019. Visual Studio must be installed in the standard location.

For other versions of visual studio, the script should be amended to add or alter the visual studio directories.

7Zip
--
[7Zip](https://www.7-zip.org/download.html) must be installed in it's default location.

Building openssl
==
```
git clone https://github.com/Mehuge/openssl-builder
cd openssl-builder\win
cmd /c build.cmd
```

The build script will download and install [perl](https://strawberryperl.com/) if necessary as well as a version of [nasm](https://www.nasm.us/) these will be placed in a bin subfolder.

Then the openssl source is downloaded and extracted into the `openssl` subfolder.

By default the build script will build 32 bit variants of openssl. To build 64 bit versions, edit the build script and set ARCH and CPU variables appropriately.

| Platform | ARCH  | CPU |
| -------- | ----- | --- |
| win32    | win32 | x86 |
| win64    | win64 | x64 |

Build output
==
| folder                       | Arch  | shared | release |
| ---------------------------- | ----- | ------ | ------- |
| openssl-win32-static-debug   | 32bit | no     | no      |
| openssl-win32-static-release | 32bit | no     | yes     |
| openssl-win32-DLL-debug      | 32bit | yes    | no      |
| openssl-win32-DLL-release    | 32bit | yes    | yes     |
| | | | |
| openssl-win64-static-debug   | 64bit | no     | no      |
| openssl-win64-static-release | 64bit | no     | yes     |
| openssl-win64-DLL-debug      | 64bit | yes    | no      |
| openssl-win64-DLL-release    | 64bit | yes    | yes     |
