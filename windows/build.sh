#!/usr/bin/env sh

set -e

rm -rf src
mkdir -p src
cd src

wget -q -O nss-with-nspr.tar.gz https://ftp.mozilla.org/pub/security/nss/releases/NSS_3_114_RTM/src/nss-3.114-with-nspr-4.37.tar.gz
tar zxf nss-with-nspr.tar.gz --strip-components 1
rm nss-with-nspr.tar.gz
echo 'DIRS = coreconf lib cmd' >> nss/manifest.mn
echo 'DIRS = certutil $(LIB_SRCDIRS)' >> nss/cmd/manifest.mn
sed -e 's|CC -mwindows|CC -fpermissive -mwindows|' \
    -e 's|CFLAGS -GT|CFLAGS|' \
    -i nspr/configure
sed -e 's|OS_CFLAGS|#OSC_FLAGS|' \
    -i nss/coreconf/WINNT.mk
sed -e 's|OS_CFLAGS|#OSC_FLAGS|' \
    -i nss/lib/sqlite/Makefile
sed -e 's|bool|value|g'\
    -i nspr/pr/src/io/prmapopt.c

cd nss
USE_64=1 BUILD_OPT=1 NSS_DISABLE_GTESTS=1 NSS_DISABLE_NSPR_TESTS=1 NS_USE_GCC=1 make nss_build_all
cd ..
mv dist/"$(cat dist/latest)" dist/out
mkdir -p ../dist
cp -L dist/out/bin/certutil.exe ../dist/
cp -L dist/out/lib/*.dll ../dist/
rm -rf ./*

cd ..
rm -rf src
