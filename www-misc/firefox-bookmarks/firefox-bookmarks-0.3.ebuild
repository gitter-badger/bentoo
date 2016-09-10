# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

EAPI="6"

DESCRIPTION="Firefox bookmarks for the Bento ISO only"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND} || (
	>=www-client/firefox-bin-15.0.1
	>=www-client/firefox-15.0.1
)"

S="${WORKDIR}"
MOZ_PN="firefox"

src_prepare() {
	cp "${FILESDIR}/bentoo-bookmarks-${PV}.html" bookmarks.html || die
	eapply_user
}

src_compile(){
	return
}

src_install(){
	declare MOZILLA_FIVE_HOME=/opt/${MOZ_PN}

	insinto ${MOZILLA_FIVE_HOME}/defaults/profile/
	doins bookmarks.html
}
