#! /bin/bash -ex

WASI_SDK_VERSIONS=(
    # 16 for 3.11 & 3.12 is special-cased below.
    24  # 3.13 (w/ special symlinking below), 3.14
    29  # 3.15
)
WASMTIME_VERSION="38.0.4"

ENV WASI_SDK_ROOT=/opt

mkdir --parents ${WASI_SDK_ROOT}

# For 3.11, 3.12.
# There is no Arm support for WASI SDK < 23.
if [ "${TARGETARCH}" = "amd64" ]; then
    URL=https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-16/wasi-sdk-16.0-linux.tar.gz
    curl --location $URL | tar --directory ${WASI_SDK_ROOT} --extract --gunzip
fi

case "${TARGETARCH}" in
    amd64) WASI_ARCH="x86_64" ;;
    arm64) WASI_ARCH="arm64" ;;
    *) echo "Unsupported TARGETARCH: ${TARGETARCH}" && exit 1 ;;
esac && \

for VERSION in "${WASI_SDK_VERSIONS[@]}"; do
    # The URL format only works for WASI SDK >= 23.
    URL=https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${VERSION}/wasi-sdk-${VERSION}.0-${WASI_ARCH}-linux.tar.gz
    curl --location $URL | tar --directory ${WASI_SDK_ROOT} --extract --gunzip
done

# For Python 3.13 as Tools/wasm/wasi.py expects /opt/wasi-sdk by default.
ln -s ${WASI_SDK_ROOT}/wasi-sdk-24.0*/ /opt/wasi-sdk

WASMTIME_HOME="/opt/wasmtime"

mkdir --parents ${WASMTIME_HOME}

case "${TARGETARCH}" in
    amd64) WASMTIME_ARCH="x86_64" ;;
    arm64) WASMTIME_ARCH="aarch64" ;;
    *) echo "Unsupported TARGETARCH: ${TARGETARCH}" && exit 1 ;;
esac

URL="https://github.com/bytecodealliance/wasmtime/releases/download/v${WASMTIME_VERSION}/wasmtime-v${WASMTIME_VERSION}-${WASMTIME_ARCH}-linux.tar.xz"

curl --location $URL |
    xz --decompress |
    tar --strip-components 1 --directory ${WASMTIME_HOME} -x

# Put `wasmtime` on $PATH.
ln -s ${WASMTIME_HOME}/wasmtime* /usr/local/bin
