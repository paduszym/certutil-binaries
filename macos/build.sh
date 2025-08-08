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
sed -e 's|DEFINES += -DUSE_HW_AES -DUSE_HW_SHA1 -DUSE_HW_SHA2||g' \
    -e 's|EXTRA_SRCS += aes-armv8.c gcm-aarch64.c sha1-armv8.c sha256-armv8.c||g' \
    -e 's|EXTRA_SRCS += aes-armv8.c sha1-armv8.c sha256-armv8.c||g' \
    nss/lib/freebl/Makefile

cat nss/lib/freebl/Makefile
#
#cd nss
#USE_64=1 BUILD_OPT=1 NSS_DISABLE_GTESTS=1 NSS_DISABLE_NSPR_TESTS=1 make nss_build_all
#cd ..
#mv dist/"$(cat dist/latest)" dist/out
#mkdir -p ../dist
#cp -L dist/out/bin/certutil ../dist/
#cp -L dist/out/lib/*.dylib ../dist/
#rm -rf ./*
#
#cd ..
#rm -rf src
