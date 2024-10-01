#!/usr/bin/env bash

sysOS=$(uname -s)
NUM_THREADS=1
if [ $sysOS == "Darwin" ]; then
  #echo "I'm MacOS"
  NUM_THREADS=$(sysctl -n hw.nCPU)
elif [ $sysOS == "Linux" ]; then
  #echo "I'm Linux"
  NUM_THREADS=$(grep ^processor /proc/cpuinfo | wc -l)
else
  echo "Other OS: $sysOS"
fi

echo "current path: $(pwd)"

rm -rf build

make clean
./Configure darwin64-x86_64-cc --prefix="$(pwd)/build/openssl-x86_64" no-asm -mmacosx-version-min=10.15
make -j4
make install

make clean
./Configure darwin64-arm64-cc --prefix="$(pwd)/build/openssl-arm64" no-asm -mmacosx-version-min=10.15
make -j4
make install

rm -rf $(pwd)/build/openssl
mkdir -p $(pwd)/build/openssl/lib $(pwd)/build/openssl/bin

cp -r $(pwd)/build/openssl-arm64/include $(pwd)/build/openssl/
lipo -create $(pwd)/build/openssl-arm64/lib/libssl.a $(pwd)/build/openssl-x86_64/lib/libssl.a -output $(pwd)/build/openssl/lib/libssl.a
lipo -create $(pwd)/build/openssl-arm64/lib/libcrypto.a $(pwd)/build/openssl-x86_64/lib/libcrypto.a -output $(pwd)/build/openssl/lib/libcrypto.a
lipo -info $(pwd)/build/openssl-arm64/bin/openssl $(pwd)/build/openssl-x86_64/bin/openssl -output $(pwd)/build/openssl/bin/openssl