* `docker/util.sh`

  The command `apt_ver` was removed. `apt` already support wildcards, just use
  `v1.8.*` instead of `v1.8.x` and pass the version explicitly to `apt`.

* `last-version`

  Support for `apt` have been removed.
