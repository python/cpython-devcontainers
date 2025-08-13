FROM docker.io/library/fedora:41

LABEL org.opencontainers.image.base.name="docker.io/library/fedora:41"
LABEL org.opencontainers.image.source="https://github.com/python/cpython-devcontainers"
LABEL org.opencontainers.image.title="CPython development container"
LABEL org.opencontainers.image.description="CPython development container with the tooling to work on Linux or WASI builds."
LABEL org.opencontainers.image.authors="Brett Cannon"

ARG TARGETARCH

ENV CC=clang

# Remove a video codec repository to speed up installs.
RUN dnf config-manager setopt fedora-cisco-openh264.enabled=False

# Update only after consulting with WASI support maintainers (see PEP 11).
ENV WASI_SDK_VERSION=24

# Update as desired.
ENV WASMTIME_VERSION=35.0.0
ENV WASMTIME_HOME=/opt/wasmtime


RUN mkdir -p /opt/cpython-devcontainer/bin
COPY --chmod=755 install-builddeps.sh install-wasi.sh /opt/cpython-devcontainer/bin/

RUN /opt/cpython-devcontainer/bin/install-builddeps.sh
RUN /opt/cpython-devcontainer/bin/install-wasi.sh
