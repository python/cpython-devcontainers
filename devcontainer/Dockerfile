FROM docker.io/library/fedora:42

LABEL org.opencontainers.image.base.name="docker.io/library/fedora:42"
LABEL org.opencontainers.image.source="https://github.com/python/cpython-devcontainers"
LABEL org.opencontainers.image.title="CPython development container"
LABEL org.opencontainers.image.description="CPython development container with the tooling to work on Linux builds."
LABEL org.opencontainers.image.authors="Brett Cannon"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.url="https://github.com/python/cpython-devcontainers"
LABEL org.opencontainers.image.documentation="https://github.com/python/cpython-devcontainers/blob/main/devcontainer/README.md"

ENV CC=clang

# Remove a video codec repository to speed up installs.
RUN dnf config-manager setopt fedora-cisco-openh264.enabled=False

RUN mkdir -p /opt/cpython-devcontainer/bin
COPY --chmod=755 install-builddeps.sh /opt/cpython-devcontainer/bin/

RUN /opt/cpython-devcontainer/bin/install-builddeps.sh
