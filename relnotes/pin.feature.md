* `apt` versions are now pinned

  Installed `apt` package versions are now
  [pinned](https://manpages.debian.org/stretch/apt/apt_preferences.5.en.html)
  with
  [priority](https://manpages.debian.org/stretch/apt/apt_preferences.5.en.html#How_APT_Interprets_Priorities)
  990 when installed to avoid accidental upgrades via when doing a `apt
  full-upgrade` or similar.

  Priority 990 means new versions won't be installed unless explicitly
  specified. If a new version is installed, it won't be downgraded.

* `docker/util.sh` learned a new command `apt_pin_install`

  This is the command used to pin package while installing it. Besides
  installing the packages passed by argument, it will add pinning information to
  `/etc/apt/preferences.d/cachalot` automatically.
