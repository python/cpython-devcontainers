FROM docker.io/library/alpine:3.19

ARG AUTOCONF_VERSION="2.71"
ARG AUTOCONF_ARCHIVE_VERSION="2023.02.20"
ARG AUTOMAKE_VERSION="1.16.5"

LABEL org.opencontainers.image.source="https://github.com/python/cpython-devcontainers"
LABEL org.opencontainers.image.base.name="docker.io/library/alpine:3.19"
LABEL org.opencontainers.image.authors="Donghee Na"
LABEL org.opencontainers.image.title="GNU Autoconf ${AUTOCONF_VERSION} container for CPython"
LABEL org.opencontainers.image.description="Container image with GNU Autoconf ${AUTOCONF_VERSION}, GNU Automake ${AUTOMAKE_VERSION}, and autoconf-archive ${AUTOCONF_ARCHIVE_VERSION} for generating CPython's configure script."

RUN apk upgrade && \
    apk add \
        alpine-sdk \
        autoconf \
        automake \
        xz
RUN set -o pipefail \
    && curl https://ftp.gnu.org/gnu/autoconf/autoconf-${AUTOCONF_VERSION}.tar.gz | tar -zxf - \
    && cd autoconf-${AUTOCONF_VERSION} \
    && ./configure --prefix=/usr/local \
    && make \
    && make install
RUN set -o pipefail \
    && curl https://ftp.gnu.org/gnu/automake/automake-${AUTOMAKE_VERSION}.tar.gz | tar -xzf - \
    && cd automake-${AUTOMAKE_VERSION} \
    && ./configure --prefix=/usr/local \
    && make \
    && make install
RUN set -o pipefail \
    && curl https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-${AUTOCONF_ARCHIVE_VERSION}.tar.xz | xz -cd - | tar -xf - \
    && cd autoconf-archive-${AUTOCONF_ARCHIVE_VERSION} \
    && ./configure --prefix=/usr/local \
    && make \
    && make install

VOLUME /src
WORKDIR /src

ADD entry.sh /
CMD ["/entry.sh"]
