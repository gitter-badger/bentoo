# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"

MY_PN="iso-latin-1"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://bitbucket.org/redeyeteam/${MY_PN}.git"
else
	SRC_URI="https://bitbucket.org/redeyeteam/${MY_PN}/get/${PV}.tar.bz2 -> ${MY_PN}-${PV}.tar.bz2"
fi

DESCRIPTION="iso-latin-1 based linux console font"
HOMEPAGE="https://bitbucket.org/redeyeteam/iso-latin-1"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
# Only installs fonts.
RESTRICT="mirror strip binchecks"

RDEPEND=""
DEPEND="${RDEPEND}
	media-gfx/psftools"

FONTDIR="/usr/share/consolefonts"

if [[ ${PV} == "9999" ]] ; then
	S="${WORKDIR}/${MY_PN}-8x16-${PV}"
else
	MY_COMMIT="d4abdbc5d721"
	S="${WORKDIR}/redeyeteam-${MY_PN}-${MY_COMMIT}"
fi

src_compile() {
	emake || die "Build failed!"
}

src_install() {
	cd "${S}/${MY_PN}-8x16-${PV}"
	insinto ${FONTDIR}
	doins "${MY_PN}-8x16.psfu.gz"
}

pkg_postinst() {
	echo
	elog "To use iso-latin-1 instead of the default console font:"
	elog "   set FONT=iso-latin-1-8x16 in /etc/vconsole.conf"
	echo
}
