### Support Ubuntu bionic for all images

* `develdlang` image: Drop D1 support

Ubuntu bionic requires builds to use position independent code
(i.e. the `-fPIC` build flag). D1 does not support it and has been dropped.

These debian packages will be no longer provided:
- dmd1
- libtangort-dmd-dev
- d1to2fix

D applications using the compiler dmd-transitional will need to add the `-fPIC`
build flag, otherwise linking will fail.
