# Copyright 1999-2015 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

EAPI=5

inherit mozilla-addon

MOZ_FILEID="215989"
DESCRIPTION="Lets you switch local proxies in firefox. A fork of multiproxy switch."
HOMEPAGE="https://addons.mozilla.org/en-GB/firefox/addon/proxy-selector/"
SRC_URI="https://addons.mozilla.org/firefox/downloads/latest/${MOZ_FILEID}/addon-${MOZ_FILEID}-latest.xpi -> ${P}.xpi"

LICENSE="MPL-1.1"
SLOT="0"
# fails to unpack, some problem with the packaging of the xpi?
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

#FIXME: it fails to unpack
#src_unpack() {
#    if [ "${A}" != "" ]; then
#	unzip -qo "${DISTDIR}/${A}" -d "${WORKDIR}/"
#    fi
#}