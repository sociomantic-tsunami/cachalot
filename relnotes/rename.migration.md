### Images renamed with a `devel` prefix

To make the distinction between runtime and development images, the current
images are renamed with the `devel` prefix:

* `base` -> `develbase`
* `dlang` -> `develdlang`

Make sure to update the image name too in your `FROM` lines when upgrading the
version number.
