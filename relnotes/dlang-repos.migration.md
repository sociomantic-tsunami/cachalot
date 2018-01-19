## Moved D related APT repositories sources to the `dlang` image

So far D related APT repositories were included in the `base` image, but there
was really no point in doing so, since there is a specifiic `dlang` image.
Please switch to use the `dlang` image if you need to use D tools and you were
using the `base` image.
