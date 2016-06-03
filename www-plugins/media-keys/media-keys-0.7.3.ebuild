# Copyrigh 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

EAPI=5

inherit mozilla-addon

MOZ_FILEID="553354"
DESCRIPTION="Lets you control various media sites using the media keys on your keyboard without having the Firefox window active."
HOMEPAGE="https://addons.mozilla.org/en-GB/firefox/addon/media-keys/"
SRC_URI="https://addons.mozilla.org/firefox/downloads/latest/${MOZ_FILEID}/platform:2/addon-${MOZ_FILEID}-latest.xpi -> ${P}.xpi"

LICENSE="MPL-1.1"
SLOT="0"
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
		target_firefox? ( www-client/firefox )
		target_firefox-bin? ( www-client/firefox-bin )
	)"
