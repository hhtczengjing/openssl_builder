@ECHO OFF
chcp 65001
cls
@SETLOCAL

perl Configure VC-WIN32 no-asm --prefix=d:\openssl_lib
nmake
nmake install

@ENDLOCAL