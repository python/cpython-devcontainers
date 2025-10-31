FROM docker.io/library/ubuntu:24.04

ARG AUTOCONF_VERSION="2.72"
ARG AUTOCONF_ARCHIVE_VERSION="2023.02.20"
ARG AUTOMAKE_VERSION="1.16.5"
# Specific revision of https://git.savannah.gnu.org/git/config.git
# for config.guess and config.sub.
ARG CONFIG_GIT_REV="00b15927496058d23e6258a28d8996f87cf1f191"

LABEL org.opencontainers.image.source="https://github.com/python/cpython-devcontainers"
LABEL org.opencontainers.image.base.name="docker.io/library/ubuntu:24.04"
LABEL org.opencontainers.image.authors="Donghee Na"
LABEL org.opencontainers.image.title="GNU Autoconf ${AUTOCONF_VERSION} container for CPython"
LABEL org.opencontainers.image.description="Container image with GNU Autoconf ${AUTOCONF_VERSION}, GNU Automake ${AUTOMAKE_VERSION}, and autoconf-archive ${AUTOCONF_ARCHIVE_VERSION} for generating CPython's configure script."
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.url="https://github.com/python/cpython-devcontainers"
LABEL org.opencontainers.image.documentation="https://github.com/python/cpython-devcontainers/blob/main/autoconf/README.md"

RUN apt-get update && \
    apt-get install -yq \
            autotools-dev \
            autoconf \
            autoconf-archive \
            build-essential \
            curl \
            git \
            pkg-config

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl https://ftp.gnu.org/gnu/autoconf/autoconf-${AUTOCONF_VERSION}.tar.gz | tar -zxf - \
    && cd autoconf-${AUTOCONF_VERSION} \
    && ./configure --prefix=/usr/local \
    && make \
    && make install
RUN curl https://ftp.gnu.org/gnu/automake/automake-${AUTOMAKE_VERSION}.tar.gz | tar -xzf - \
    && cd automake-${AUTOMAKE_VERSION} \
    && ./configure --prefix=/usr/local \
    && make \
    && make install
# We can get rid of the ax_c_float_words_bigendian.m4 patch when a new version
# of autoconf-archive is released.
COPY ax_c_float_words_bigendian.diff .
RUN PATCH_VERBOSE=1 curl https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-${AUTOCONF_ARCHIVE_VERSION}.tar.xz | xz -cd - | tar -xf - \
    && cd autoconf-archive-${AUTOCONF_ARCHIVE_VERSION} \
    && patch -p1 -i ../ax_c_float_words_bigendian.diff \
    && ./configure --prefix=/usr/local \
    && make \
    && make install
ADD --chmod=755 https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=${CONFIG_GIT_REV} \
    /usr/local/share/autoconf/build-aux/config.guess
ADD --chmod=755 https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=${CONFIG_GIT_REV} \
    /usr/local/share/autoconf/build-aux/config.sub
COPY config.sub.patch .
RUN p=$(pwd)/config.sub.patch \
    && cd /usr/local/share/autoconf/build-aux \
    && patch -p1 <$p \
    && rm "$p"

# https://stackoverflow.com/questions/8811381/possibly-undefined-macro-ac-msg-error/49103418#49103418
RUN cp /usr/local/share/aclocal/*.m4 /usr/share/aclocal \
    && cp /usr/share/aclocal/*.m4 /usr/local/share/aclocal

VOLUME /src
WORKDIR /src

ADD entry.sh /
CMD ["/entry.sh"]
