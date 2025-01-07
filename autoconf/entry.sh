#!/bin/sh
set -e

export CONFIG_SHELL="/usr/bin/bash"

BIN=/usr/local/bin
AUTOCONF=$BIN/autoconf
AUTORECONF=$BIN/autoreconf

if [ "$#" = "0" ]; then
    # This is the same sentinel used for AC_CONFIG_SRCDIR in CPython's
    # configure.ac.
    SENTINEL=/src/Include/object.h

    if [ ! -e ${SENTINEL} ]; then
        echo "ERROR: ${SENTINEL} not found "
        echo "Did you forget to mount Python work directory with '-v.:/src'?"
        echo
        echo "  docker run -v\$PWD:/src ghcr.io/python/cpython-autoconf"
        echo "  podman run -v\$PWD:/src:Z ghcr.io/python/cpython-autoconf"
        exit 2
    fi

    echo "Rebuilding configure script using $($AUTOCONF --version | head -n 1)"
    set -x
    # autoreconf's '--force' option doesn't affect any of the files installed
    # by the '--install' option.  Remove the files to truly force them to be
    # updated so that the CPython repo doesn't drift from this repo.
    rm -f /src/aclocal.m4
    rm -f /src/config.guess
    rm -f /src/config.sub
    rm -f /src/install-sh
    exec $AUTORECONF -ivf -Werror $@
fi

exec "$@"
