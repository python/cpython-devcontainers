#! /bin/bash -ex

# Install build tools and CPython dependencies on Fedora.


# Define dependencies as an array, for easier formatting & comments.
# see: https://www.gnu.org/software/bash/manual/html_node/Arrays.html
# Contents inspired by experience and
# https://github.com/devcontainers/features/tree/main/src/common-utils .
DEPS=(
    # Bare minimum
    /usr/bin/{blurb,clang,git}

    # Shell niceties
    /usr/bin/{fish,zsh}
    bash-completion
    bash-color-prompt

    # Common tools
    /usr/bin/{curl,grep,less,ln,lsof,man,rg,which}

    # Compression
    /usr/bin/{tar,xz,zip}

    # Editors
    /usr/bin/{emacs,vim}

    # Necessary for getting Python build dependencies
    'dnf5-command(builddep)'

    # LLVM sanitizer runtimes
    compiler-rt

    # TODO: remove when Fedora version includes Python 3.14
    libzstd-devel
)

dnf -y --nodocs --setopt=install_weak_deps=False install ${DEPS[@]}
dnf -y --nodocs --setopt=install_weak_deps=False builddep python3

# Don't leave caches in the container
dnf -y clean all
