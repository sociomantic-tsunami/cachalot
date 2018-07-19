### Removal of Bintray tools repository

Now the provided images don't provide the `tools` Debian repository anymore, it only contained tools for developers, not for automated testing.

If your project needs some of the tools for some reason, you can get them back by adding this to your setup script:

```sh
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 379CE192D401AB61
echo '# Sociomantic Tsunami repos' \
	> /etc/apt/sources.list.d/sociomantic-tsunami.list
echo "deb https://dl.bintray.com/sociomantic-tsunami/tools $(lsb_release -cs) release prerelease" \
	>> /etc/apt/sources.list.d/sociomantic-tsunami.list
```
