# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"

inherit mozilla-addon

MOZ_FILEID="229918"
DESCRIPTION="Encrypt the web! HTTPS Everywhere is a Firefox extension that encrypts your communications."
HOMEPAGE="https://www.eff.org/HTTPS-EVERYWHERE https://addons.mozilla.org/en-GB/firefox/addon/https-everywhere/"
SRC_URI="http://addons.mozilla.org/firefox/downloads/latest/${MOZ_FILEID} -> ${P}.xpi"

LICENSE="GPL-2 GPL-3"
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
