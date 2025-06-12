#! /bin/bash -ex

# Install build tools and CPython dependencies on Fedora.


# Define dependencies as an array, for easier formatting & comments.
# see: https://www.gnu.org/software/bash/manual/html_node/Arrays.html
DEPS=(
    /usr/bin/{blurb,clang,curl,git,ln,tar,xz}
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
