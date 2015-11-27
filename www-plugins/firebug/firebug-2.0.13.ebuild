# Copyright 1999-2015 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

EAPI=5

inherit mozilla-addon

MOZ_FILEID="1843"
DESCRIPTION="Powerful web development tool for firefox"
HOMEPAGE="http://getfirebug.com https://addons.mozilla.org/en-GB/firefox/addon/firebug/"
SRC_URI="https://addons.mozilla.org/firefox/downloads/latest/${MOZ_FILEID}/addon-${MOZ_FILEID}-latest.xpi -> ${P}.xpi"

LICENSE="BSD"
SLOT="0"
# blocked because it pulls firefox-bin when I want to keep firefox only
KEYWORDS="amd64 x86"
IUSE="+symlink_all_targets target_firefox target_firefox-bin"

# symlink all possible target paths if this is set
if use symlink_all_targets; then
	MZA_TARGETS="firefox firefox-bin"
else
	use target_firefox && MZA_TARGETS+=" firefox"
	use target_firefox-bin && MZA_TARGETS+=" firefox-bin"
fi

RDEPEND="
	!symlink_all_targets? (
		target_firefox? ( >=www-client/firefox-31.2.0-r1 )
		target_firefox-bin? ( >=www-client/firefox-bin-31.2.0-r1 )
	)"