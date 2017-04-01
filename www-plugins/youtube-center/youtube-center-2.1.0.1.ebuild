# Copyright 1999-2017 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"

inherit mozilla-addon

DESCRIPTION="Make YouTube much more entertaining."
HOMEPAGE="https://github.com/YePpHa/YouTubeCenter https://addons.mozilla.org/en-GB/firefox/addon/youtube-center/"
if [[ ${PV} == "9999" ]] ; then
    SRC_URI="https://github.com/YePpHa/YouTubeCenter/raw/master/dist/YouTubeCenter.xpi -> ${P}.xpi"
else
    MOZ_FILEID="240658"
    SRC_URI="http://addons.mozilla.org/downloads/file/${MOZ_FILEID} -> ${P}.xpi"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+symlink_all_targets target_firefox target_firefox-bin"

RDEPEND="
	!symlink_all_targets? (
		target_firefox? ( www-client/firefox )
		target_firefox-bin? ( www-client/firefox-bin )
	)"

src_install() {
	# symlink all possible target paths if this is set
	if use symlink_all_targets; then
		MZA_TARGETS="firefox firefox-bin"
	else
		use target_firefox && MZA_TARGETS+=" firefox"
		use target_firefox-bin && MZA_TARGETS+=" firefox-bin"
	fi
	mozilla-addon_src_install
}
