# Copyright 1999-2017 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"

inherit mozilla-addon

MOZ_FILEID="521554"
DESCRIPTION="Protects you against tracking through \"free\", centralized, content delivery."
HOMEPAGE="https://addons.mozilla.org/en-GB/firefox/addon/decentraleyes/"
SRC_URI="https://addons.mozilla.org/firefox/downloads/latest/${MOZ_FILEID}/addon-${MOZ_FILEID}-latest.xpi -> ${P}.xpi"

LICENSE="MPL-2.0"
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
