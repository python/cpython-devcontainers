FROM docker.io/library/fedora:41

ARG TARGETARCH


ENV CC=clang

RUN dnf -y --nodocs --setopt=install_weak_deps=False --disablerepo=fedora-cisco-openh264 install \
        /usr/bin/{blurb,clang,curl,git,ln,tar,xz} \
        compiler-rt \
        # TODO: remove when Fedora version includes Python 3.14+
        libzstd-devel \
        'dnf5-command(builddep)' && \
    dnf -y --nodocs --setopt=install_weak_deps=False --disablerepo=fedora-cisco-openh264 \
        builddep python3 && \
    dnf -y clean all


ENV WASI_SDK_VERSION=24
ENV WASI_SDK_PATH=/opt/wasi-sdk

RUN mkdir ${WASI_SDK_PATH} && \
    case "${TARGETARCH}" in \
        amd64) WASI_ARCH="x86_64" ;; \
        arm64) WASI_ARCH="arm64" ;; \
        *) echo "Unsupported TARGETARCH: ${TARGETARCH}" && exit 1 ;; \
    esac && \
    curl --location https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${WASI_SDK_VERSION}/wasi-sdk-${WASI_SDK_VERSION}.0-${WASI_ARCH}-linux.tar.gz | \
    tar --strip-components 1 --directory ${WASI_SDK_PATH} --extract --gunzip


ENV WASMTIME_HOME=/opt/wasmtime
ENV WASMTIME_VERSION=33.0.0

RUN mkdir --parents ${WASMTIME_HOME} && \
    case "${TARGETARCH}" in \
        amd64) WASMTIME_ARCH="x86_64" ;; \
        arm64) WASMTIME_ARCH="aarch64" ;; \
        *) echo "Unsupported TARGETARCH: ${TARGETARCH}" && exit 1 ;; \
    esac && \
    curl --location "https://github.com/bytecodealliance/wasmtime/releases/download/v${WASMTIME_VERSION}/wasmtime-v${WASMTIME_VERSION}-${WASMTIME_ARCH}-linux.tar.xz" | \
    xz --decompress | \
    tar --strip-components 1 --directory ${WASMTIME_HOME} -x && \
    ln -s ${WASMTIME_HOME}/wasmtime /usr/local/bin


