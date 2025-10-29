FROM ghcr.io/python/devcontainer:latest

LABEL org.opencontainers.image.base.name="ghcr.io/python/devcontainer:latest"
LABEL org.opencontainers.image.source="https://github.com/python/cpython-devcontainers"
LABEL org.opencontainers.image.title="CPython WASI development container"
LABEL org.opencontainers.image.description="CPython development container with the tooling to work on WASI builds."
LABEL org.opencontainers.image.authors="Brett Cannon"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.url="https://github.com/python/cpython-devcontainers"
LABEL org.opencontainers.image.documentation="https://github.com/python/cpython-devcontainers/blob/main/wasicontainer/README.md"

ARG TARGETARCH

# WASI SDK versions are controlled in install-wasi.sh.
ENV WASI_SDK_ROOT=/opt

ENV WASMTIME_VERSION=38.0.2
ENV WASMTIME_HOME=/opt/wasmtime

RUN mkdir -p /opt/cpython-devcontainer/bin
COPY --chmod=755 install-wasi.sh /opt/cpython-devcontainer/bin/

RUN /opt/cpython-devcontainer/bin/install-wasi.sh
