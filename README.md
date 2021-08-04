[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/jemand771/latex-build/docker-build?style=for-the-badge)](https://github.com/jemand771/latex-build/actions)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/jemand771/latex-build?style=for-the-badge)](https://github.com/jemand771/latex-build/releases/latest)
[![GHCR](https://img.shields.io/badge/GHCR-same_as_---->-blue.svg?style=for-the-badge)](https://github.com/jemand771/latex-build/pkgs/container/latex-build)
[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/jemand771/latex-build?label=docker%20hub&sort=semver&style=for-the-badge)](https://hub.docker.com/repository/docker/jemand771/latex-build)
[![PRs Welcome](https://img.shields.io/badge/Pull_requests-welcome-brightgreen.svg?style=for-the-badge)](https://github.com/jemand771/latex-build/compare)
# latex-build
A docker container for building LaTeX documents. Designed for [DSczyrba/Vorlage-Latex](https://github.com/DSczyrba/Vorlage-Latex)

## Quickstart
The container is supposed to be created and run exactly once per build.
```
docker run --rm -v \"$(pwd):/latex\" ghcr.io/jemand771/latex-build"
```
This will try to build the file `main.tex` in the current working directory into a `main.pdf`. See below for more info on configuration options.

## Configuration
### Container user
It's recommended to not have the container run as root internally but rather with the same uid:gid as the user on the host system. This can be achieved by specifying
```
docker run -u $(id -u ${USER}):$(id -g ${USER}) [...]
```

### Init process
Some features like diff-pdf might require the container to be run with an it process like this:
```
docker run --init [...]
```
There will notes on all affected features in the feature list below.


### Environment variables
Environment variables for the container can be set using the `-e` flag. Use the flag multiple times if you'd like to set multiple parameters.
```
docker run -e FOO=BAR -e HELLO=WORLD [...]
```
The table below lists all environment variables declared in the Dockerfile. You may modify all of them in any way you like, however, certain values might cause unexpected behaviour. Stick to the instructions in the features chapter if you're unsure.
| variable name      | default value | description |
| ------------------ | ------------- | ----------- |
| BIND_PATH          | /latex        | The path specified after `-v` the container will use internally. There is no need to change this unless you're integrating this container into a build script that can't be changed. |
| BUILD_DIRECTORY    | .build        | The name of the temporary directory used for building. This will appear inside both `$BIND_PATH` and the host folder bound to it. Change this if you don't like the name. |
| CLEAN_BUILD=       |               | Set this to a non-empty value to enable clean builds - this will delete the `$BUILD_DIRECTORY` folder bevore proceeding. |
| DELETE_TEMP=       |               | Like clean builds, but the other way around: Build and clean up afterwards (note: this might still use the build cache from before if it exists.) |
| DISABLE_DIFFPDF=   |               | Disable the diff-pdf feature. See below. |
| DISABLE_PYTHONTEX= |               | Disable the pythontex feature. See below. |
| DISABLE_SYNCTEX=   |               | Disable the synctex feature. See below. |
| HOST_PATH=         |               | Optional argument to tell the container which path `$BIND_PATH` is bound to. Set this to the host path specified after `-v`. |
| TARGET             | main          | Name of the LaTeX target file without extension. All resulting files will be named after this, i.e. `$TARGET.pdf`, `$TARGET.synctex.gz`, ... |
| WARNINGS           | -Wall         | Warning options to pass to [`latexrun.py`](https://github.com/aclements/latexrun). Use this to silence certain warnings. |

## Features
### Basics

### Diff-PDF

### Pythontex

### Synctex
