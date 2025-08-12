FROM alpine:3.22.1 AS builder
RUN apk add --no-cache zip

FROM builder AS dist
ARG VERSION
ARG OS
ARG ARCH
WORKDIR /dist
RUN --mount=source=./${OS}/dist/${ARCH},target=/dist/certutil_${VERSION}_${OS}-${ARCH} \
    zip -q -r certutil_${VERSION}_${OS}-${ARCH}.zip * && \
    sha256sum certutil_${VERSION}_${OS}-${ARCH}.zip | awk '{printf $1}' > certutil_${VERSION}_${OS}-${ARCH}.zip.sha256

FROM scratch
COPY --from=dist /dist /
