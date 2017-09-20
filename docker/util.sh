# Copyright sociomantic labs GmbH 2017.
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)
#
# Utility library to use in scripts

# This function installs packages with specific versions and also pin them
# (with prio 990) to those versions by appending pinning information to
# /etc/apt/preferences.d/cachalot, so they are not upgraded accidentally.
#
# All packages should be specified with version: pkg=version.
#
# Version can have wildcards, see apt-get/apt_preferences documentation for
# details
apt_pin_install()
{
	( { set +x -e; } 2>/dev/null # disable verboseness (silently)

	# Pin the packages
	for pkg_ver in "$@"
	do
		pkg="$(echo "$pkg_ver" | cut -d= -f1)"
		ver="$(echo "$pkg_ver" | cut -d= -f2-)"

		# If we still have a version, print the pinning spec to Prio
		# 990 means don't install newer versions, but don't downgrade
		# if installed is newer.
		# https://manpages.debian.org/stretch/apt/apt_preferences.5.en.html#How_APT_Interprets_Priorities
		cat <<EOT >> /etc/apt/preferences.d/cachalot
Package: $pkg
Pin: version $ver
Pin-Priority: 990

EOT
	done

	# Install the packages
	apt -y install "$@"
	)
}


gem_ver()
{
	( { set +x -e; } 2>/dev/null # disable verboseness (silently)
	pkg="$1"
	ver="$2"

	# If there is a $ver specified, then get the latest one
	ver="${ver:+$(./last-version gem "$pkg" "$ver")}"

	# If we still have a version, then pass it to apt explicitly
	echo "${ver:+--version=$ver }$pkg"
	)
}

cleanup()
{
	apt-get autoremove -y
	rm -fr /var/lib/apt/lists/*
}
