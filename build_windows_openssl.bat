@ECHO OFF
chcp 65001
cls
@SETLOCAL

nmake clean
perl Configure VC-WIN32 no-asm --prefix="$(pwd)/build/openssl-win32"
nmake
nmake install

nmake clean
perl Configure VC-WIN64A no-asm --prefix="$(pwd)/build/openssl-win64"
nmake
nmake install

@ENDLOCAL