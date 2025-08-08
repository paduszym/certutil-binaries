ARG ARCH

FROM alpine:3.21.3 AS src
WORKDIR /src
RUN wget -q -O nss-with-nspr.tar.gz https://ftp.mozilla.org/pub/security/nss/releases/NSS_3_114_RTM/src/nss-3.114-with-nspr-4.37.tar.gz && \
    tar zxf nss-with-nspr.tar.gz --strip-components 1 && \
    rm nss-with-nspr.tar.gz && \
    echo 'DIRS = coreconf lib cmd' >> nss/manifest.mn && \
    echo 'DIRS = certutil $(LIB_SRCDIRS)' >> nss/cmd/manifest.mn

FROM --platform=linux/${ARCH} debian:12.10-slim AS builder
RUN apt update && \
    apt-get install -y build-essential
WORKDIR /src
COPY --from=src /src .
RUN cd nss && \
    USE_64=1 BUILD_OPT=1 NSS_DISABLE_GTESTS=1 NSS_DISABLE_NSPR_TESTS=1 make nss_build_all && \
    cd .. && \
    mv dist/$(cat dist/latest) dist/out && \
    mkdir /dist && \
    cp -L dist/out/bin/certutil /dist && \
    cp -L dist/out/lib/*.so /dist && \
    rm -rf *
RUN mkdir testdb && \
    LD_LIBRARY_PATH=/dist /dist/certutil -N -d sql:./testdb --empty-password && \
    LD_LIBRARY_PATH=/dist /dist/certutil -L -d sql:./testdb && \
    rm -rf testdb

FROM scratch
COPY --from=builder /dist /
