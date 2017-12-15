## Add `prerelease` Bintray repositories

Now `prerelease` Bintray repositories are available, although with a negative
apt priority, so packages in those repositories will never be installed
automatically (you need to use `apt install pkg=version` to install).

This will ease doing test of pre-release versions.
