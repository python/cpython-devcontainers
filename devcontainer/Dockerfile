FROM docker.io/library/fedora:41

ARG TARGETARCH

ENV CC=clang

# Remove a video codec repository to speed up installs
RUN dnf config-manager setopt fedora-cisco-openh264.enabled=False

# Update only after consulting with WASI support maintainers (see PEP 11).
ENV WASI_SDK_VERSION=24
ENV WASI_SDK_PATH=/opt/wasi-sdk

# Update as desired.
ENV WASMTIME_VERSION=33.0.0
ENV WASMTIME_HOME=/opt/wasmtime


RUN mkdir -p /opt/cpython-devcontainer/bin
COPY --chmod=755 install-builddeps.sh install-wasi.sh /opt/cpython-devcontainer/bin/

RUN /opt/cpython-devcontainer/bin/install-builddeps.sh
RUN /opt/cpython-devcontainer/bin/install-wasi.sh
