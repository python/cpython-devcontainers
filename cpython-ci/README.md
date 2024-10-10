# CI Images for Python

This is an official Docker image containing various stable and in-development
Python releases.  It is based on [Ubuntu 24.04 LTS](http://releases.ubuntu.com/24.04/).

The `active` (a.k.a. `main`) image contains all of the currently maintained
versions of Python. None of the [EOL'd](https://endoflife.date/python)
versions are built or are available for testing purposes. Note that we
recommend against using `main` as it may soon be
[deprecated](https://gitlab.com/python-devs/ci-images/-/issues/20).  These are
the current versions that are available:

<!---
It would be great if we could create this list dynamically, since it's the we already auto-detect the active
versions from the git tags.  For now, when new versions come out, I just edit this list manually, using the
GitLab web UI.
--->

* [Python 3.14.0a0 - unreleased](https://github.com/python/cpython)
* [Python 3.13.0](https://www.python.org/downloads/release/python-3130/)
* [Python 3.12.7](https://www.python.org/downloads/release/python-3127/)
* [Python 3.11.10](https://www.python.org/downloads/release/python-31110/)
* [Python 3.10.15](https://www.python.org/downloads/release/python-31015/)
* [Python 3.9.20](https://www.python.org/downloads/release/python-3920/)

# Python executables

Each supported Python version can be invoked directly using the `pythonX.Y` executable, all of which live in
parallel in `/usr/local/bin` (generally on `$PATH`).  For example:

```
$ python3.12 -V
```

As of Python 3.13, both the standard build and the [free-threading (a.k.a. "No
GIL")](https://py-free-threading.github.io/) binaries are available.  The
free-threading binary has a `t` at the end, e.g.

```
$ python3.13t -V
```

# Using the image

We are publishing this Docker image on
[GitLab](https://gitlab.com/python-devs/ci-images/container_registry).

For example:

```
$ docker run registry.gitlab.com/python-devs/ci-images:active python3.11 -c "import sys; print(sys.version)"
```

You can pull the container with this command:

```
$ docker pull registry.gitlab.com/python-devs/ci-images:active
```

[//]: # (TODO: Reword for GH Actions)
If you want to use this image in your own CI pipelines (e.g. a
[.gitlab-ci.yml](https://gitlab.com/help/ci/yaml/README.md) file for a GitLab
shared runner), use this URL to refer to the image:

```
registry.gitlab.com/python-devs/ci-images:active
```

Here's [an example](https://gitlab.com/warsaw/gitlab-ci/-/blob/main/common-gitlab-ci.yml#L45).

# Contributing

Feel free to help us by submitting
[merge requests](https://gitlab.com/python-devs/ci-images/merge_requests) or
[issues](https://gitlab.com/python-devs/ci-images/issues).
