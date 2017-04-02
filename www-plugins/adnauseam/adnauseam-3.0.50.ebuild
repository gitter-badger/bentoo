# Copyright 1999-2017 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"

inherit mozilla-addon

MOZ_FILEID="585454"
DESCRIPTION="Fight back against advertising surveillance."
HOMEPAGE="https://adnauseam.io https://addons.mozilla.org/en-GB/firefox/addon/adnauseam/"
SRC_URI="https://addons.mozilla.org/firefox/downloads/latest/${MOZ_FILEID}/addon-${MOZ_FILEID}-latest.xpi -> ${P}.xpi"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+symlink_all_targets target_firefox target_thunderbird target_seamonkey target_firefox-bin target_thunderbird-bin target_seamonkey-bin"

RDEPEND="
	!symlink_all_targets? (
		target_firefox? ( www-client/firefox )
		target_firefox-bin? ( www-client/firefox-bin )
		target_seamonkey? ( www-client/seamonkey )
		target_seamonkey-bin? ( www-client/seamonkey-bin )
		target_thunderbird? ( mail-client/thunderbird )
		target_thunderbird-bin? ( mail-client/thunderbird-bin )
	)"

src_prepare(){
	# the install rdf seems really 'old', with restriction on FF <10.0 ... but it works as well
	# also see: bug https://bugs.gentoo.org/show_bug.cgi?id=515192
	ipatch push . "${FILESDIR}/adnauseam-${PV}-install.rdf.patch"
	eapply_user
}

src_install() {
	# symlink all possible target paths if this is set
	if use symlink_all_targets; then MZA_TARGETS="firefox thunderbird seamonkey
		firefox-bin thunderbird-bin seamonkey-bin"
	else
		use target_firefox && MZA_TARGETS+=" firefox"
		use target_firefox-bin && MZA_TARGETS+=" firefox-bin"
		use target_thunderbird && MZA_TARGETS+=" thunderbird"
		use target_thunderbird-bin && MZA_TARGETS+=" thunderbird-bin"
		use target_seamonkey && MZA_TARGETS+=" seamonkey"
		use target_seamonkey-bin && MZA_TARGETS+=" seamonkey-bin"
	fi
	mozilla-addon_src_install
}