#! /bin/bash -ex

# Install the WASI SDK.
# This should be portable to any Linux, but is only tested in the devcontainer.


mkdir ${WASI_SDK_PATH}

case "${TARGETARCH}" in
    amd64) WASI_ARCH="x86_64" ;;
    arm64) WASI_ARCH="arm64" ;;
    *) echo "Unsupported TARGETARCH: ${TARGETARCH}" && exit 1 ;;
esac && \

URL=https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${WASI_SDK_VERSION}/wasi-sdk-${WASI_SDK_VERSION}.0-${WASI_ARCH}-linux.tar.gz

curl --location $URL | tar --strip-components 1 --directory ${WASI_SDK_PATH} --extract --gunzip


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

ln -s ${WASMTIME_HOME}/wasmtime /usr/local/bin
