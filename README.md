Docker Images Generation
========================

The `build-img` script can generate images for a particular distro based on only one Dockerfile.

The `docker/` directory contains all the script needed to use when building images.

Please take a look to the `Makefile` for configuration options.

`make`, `make all` and `make build` will build the docker images locally. If no `TAG` variable is specified, then only the images with the form `ORG/IMG:DIST-vX` will be generated, as well as the `ORG/IMG` which will only be tagged for the `LATEST_DIST` distribution.

If `make build TAG=v2.0.1` is used (for example), the image `ORG/IMG:DIST-v2.0.1` will be tagged too.

If a `TAG` is specified but is a pre-release (as per SemVer, i.e. it contains a `-`), the default tagged image will be `ORG/IMG:DIST-vX-test` (instead of `ORG/IMG:DIST-vX`) and `ORG/IMG` will not be tagged at all.

`make push` will push all the images that would be generated by `make build` (same rules apply for `TAG`).

Docker Images Publishing
========================

Images are automatically published for tags via [Travis](https://travis-ci.org/sociomantic-tsunami/cachalot) to [DockerHub](https://travis-ci.org/sociomantic-tsunami/cachalot/settings)'s [sociomantictsunami](https://cloud.docker.com/u/sociomantictsunami/repository/list) organization.

Credentials used to push the images are stored in the [Travis repository settings](https://travis-ci.org/sociomantic-tsunami/cachalot/settings).

Internal cachalot user
======================

As part of development base image generation (`develbase`), user named `cachalot` will be created. It is intended to be used to run tests without accidental `root` access which may affect the result.

This user is added to `sudoers` with a permission to run any `sudo` command without a password. This is primarily to be able to install new packages as part of the testing script - when such `root` access is not necessary, it is recommended to use host user ID instead.
