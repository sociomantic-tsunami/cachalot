# Copyright dunnhumby Germany GmbH 2017.
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

apt_update_and_install_base_packages()
{
	# Do not install recommended packages by default
	echo 'APT::Install-Recommends "0";' > /etc/apt/apt.conf.d/99no-recommends

	# Make sure our packages list is updated
	apt update

	# Get the current distribution name
	apt -y install lsb-release
	dist="$(lsb_release -cs)"

	# Select extra packages depending on the distro version
	case "$dist" in
	bionic)
		extra_packages="gpg-agent"
		;;
	xenial)
		extra_packages="gnupg-agent gnupg-curl"
		;;
	*)
		extra_packages=
		;;
	esac

	# We install some basic packages first.
	apt -y install apt-transport-https software-properties-common curl dirmngr \
			$extra_packages
}

apt_install_bintray_key()
{
	apt-key adv --keyserver hkps://keys.openpgp.org --recv-keys 379CE192D401AB61
}

apt_add_bintray_repos()
{
	dist="$(lsb_release -cs)"
	apt_install_bintray_key
	for repo in "$@"
	do
		echo "deb https://dl.bintray.com/$repo $dist release prerelease" \
			> /etc/apt/sources.list.d/$(echo "$repo" | tr / -).list
	done

	# Add apt_preferences file
	sed 's/\${DIST}/'$dist'/g' bintray-apt-preferences > /etc/apt/preferences.d/cachalot-bintray
}

cleanup()
{
	apt-get autoremove -y
	rm -fr /var/lib/apt/lists/*
}
