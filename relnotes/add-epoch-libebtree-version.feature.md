###  Add epoch for libebtree version

* `develdlang` image

The new packages for libebtree support the new dpkg's epoch, so that the
ordering can be preserved for the new versions using `.sX` scheme.
This change makes possible to use the latest libebtree package (pre-release or
release) available in the repository for Ubuntu xenial and bionic distributions
when building the image.
