#!/bin/sh

set -ex

cleanup_after_install () {
    find /usr/local -depth -type d -a  -name test -o -name tests -o  -type f -a -name '*.pyc' -o -name '*.pyo' -exec rm -rf '{}' +
    rm -rf /usr/src/python
}


get_install () {
    # The line of input will include a single version number for all active release versions, but it will
    # include two version numbers for pre-release Pythons.  For the latter, we want the exact Python version
    # for the source tarball and the MAJOR.MINOR.PATCH for the FTP directory the tarball will live in.
    PY_VERSION=$1
    PY_DIR=${2:-$1}
    # Now we want just the major and minor version numbers, because for all Pythons >= 3.13, we want to build
    # both the standard build and the free-threading build.
    MAJOR=$(echo "$PY_DIR" | cut -d. -f1)
    MINOR=$(echo "$PY_DIR" | cut -d. -f2)
    # Download the tarball, unpack it, configure, and build it.  Then we can remove the downloaded artifacts.
    cd /tmp
    wget -q https://www.python.org/ftp/python/$PY_DIR/Python-$PY_VERSION.tar.xz
    tar Jxf Python-$PY_VERSION.tar.xz
    cd /tmp/Python-$PY_VERSION
    # For Python's >= 3.13, also build the free-threading version.  This will install /usr/local/bin/pythonX.Y
    # *and* /usr/local/bin/pythonX.Yt where the 't' version is free-threaded.  We have to do this first
    # because we want the non-t version (i.e. the default build) to be available on /usr/local/bin/pythonX.Y
    # which the latter build will overwrite.
    if [ "$MAJOR" -gt 3 ] || { [ "$MAJOR" -eq 3 ] && [ "$MINOR" -ge 13 ]; }; then
        ./configure -C --disable-gil && make -j4 && make -j4 altinstall
        make distclean
    fi
    # Build the default build for all active versions.
    ./configure -C && make -j4 && make -j4 altinstall
    cd /tmp
    rm Python-$PY_VERSION.tar.xz && rm -r Python-$PY_VERSION
}


# Install tagged Python releases.
while read ver; do
    get_install $ver
done <versions.txt


# Get and install Python rolling devel from the latest git install.
#
# 2022-11-07(warsaw): This isn't very reliable.  During the alpha release
# cycle, both the `main` branch and the downloaded tarball install `python3.N`
# executables, but with incompatible -V output.  And the tarball actually
# overrides the release branch.  Since very few people actually test against
# alpha releases, it's not likely worth it.
#
# https://gitlab.com/python-devs/ci-images/-/issues/24
#
cd  /tmp/
wget -q https://github.com/python/cpython/archive/main.zip
unzip -qq main.zip
cd /tmp/cpython-main
./configure -C && make -j4 && make -j4 altinstall
make distclean
./configure -C --disable-gil && make -j4 && make -j4 altinstall
# # Remove the git clone.
rm -r /tmp/cpython-main && rm /tmp/main.zip

# After we have installed all the things, we cleanup tests and unused files
# like .pyc and .pyo
cleanup_after_install
