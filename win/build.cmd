@echo off

set OPENSSL_VERSION=1.1.1j
set PERL_VERSION=5.32.1.1
set NASM_VERSION=2.15.05
set ARCH=win32
set UARCH=WIN32
set CPU=x86

cd ../win || exit
if not exist bin mkdir bin
goto main

:install_perl
  cd bin
  powershell -File ../install-perl.ps1 "%PERL_VERSION%"
  if not exist perl-portable exit
  PATH %PATH%;%~dp0bin\perl-portable\perl\bin
  cd ..
  exit /b

:install_nasm
  cd bin
  powershell -File ../install-nasm.ps1 "%NASM_VERSION%" "%ARCH%"
  if not exist nasm-%ARCH% exit
  PATH %PATH%;%~dp0bin\nasm-%ARCH%
  cd ..
  exit /b

:find_7zip
  if exist "C:\Program Files (x86)\NCH Software\Components\7zip" PATH %PATH%;C:\Program Files (x86)\NCH Software\Components\7zip;
  exit /b

:find_vs_buildtools
  if exist "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" (
    call "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" %CPU%
    goto found_vs_buildtools
  )
  if exist "C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" (
    call "C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Auxiliary\Build\vcvarsall.bat" %CPU%
    goto found_vs_buildtools
  )
  if exist "%VS140COMNTOOLS%\..\..\VC\vcvarsall.bat" (
    call "%VS140COMNTOOLS%\..\..\VC\vcvarsall.bat" %CPU%
    goto found_vs_buildtools
  )
  if exist "%VS120COMNTOOLS%\..\..\VC\vcvarsall.bat" (
    call "%VS120COMNTOOLS%\..\..\VC\vcvarsall.bat" %CPU%
    goto found_vs_buildtools
  )
  if exist "%VS110COMNTOOLS%\..\..\VC\vcvarsall.bat" (
    call "%VS110COMNTOOLS%\..\..\VC\vcvarsall.bat" %CPU%
    goto found_vs_buildtools
  )
  :found_vs_buildtools
  exit /b

:main

where perl 2>nul
if errorlevel 1 call :install_perl

where nasm 2>nul
if errorlevel 1 call :install_nasm

where 7zip 2>nul
if errorlevel 1 call :find_7zip

where nmake 2>nul
if errorlevel 1 call :find_vs_buildtools

:check_have_all
echo.
echo Using following build tools...
where perl nasm nmake 7Zip
echo.
if errorlevel 1 (
  echo "Could not find all the necessary build tools, bailing."
  exit 1
)

:download_openssl_source
if not exist openssl (
  echo.
  echo Downloading openssl...
  if not exist openssl.tar.gz powershell -File download-openssl.ps1 "%OPENSSL_VERSION%"
  if exist openssl.tar.gz (
    7Zip x openssl.tar.gz
    7Zip x openssl.tar openssl-%OPENSSL_VERSION%
    del openssl.tar
    move openssl-%OPENSSL_VERSION% openssl
  )
  echo.
)

cd openssl

echo.
echo Building openssl for %ARCH%-%1

:debug_build
if exist makefile nmake clean
set OPENSSL_PREFIX=%~dp0openssl-%ARCH%-static-debug
perl Configure --debug debug-VC-%UARCH% no-shared --prefix=%OPENSSL_PREFIX% --openssldir=%OPENSSL_PREFIX%
nmake
nmake test
nmake install

:release_build
if exist makefile nmake clean
set OPENSSL_PREFIX=%~dp0openssl-%ARCH%-static-release
perl Configure --release VC-%UARCH% no-shared --prefix=%OPENSSL_PREFIX% --openssldir=%OPENSSL_PREFIX%
nmake
nmake test
nmake install

:debug_build_dll
if exist makefile nmake clean
set OPENSSL_PREFIX=%~dp0openssl-%ARCH%-DLL-debug
perl Configure --debug debug-VC-%UARCH% shared --prefix=%OPENSSL_PREFIX% --openssldir=%OPENSSL_PREFIX%
nmake
nmake test
nmake install

:release_build_dll
if exist makefile nmake clean
set OPENSSL_PREFIX=%~dp0openssl-%ARCH%-DLL-release
perl Configure --release VC-%UARCH% shared --prefix=%OPENSSL_PREFIX% --openssldir=%OPENSSL_PREFIX%
nmake
nmake test
nmake install

:done
