# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
KEYWORDS="amd64 arm x86"
DESCRIPTION="Bentoo wine meta ebuild"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
SLOT="0"
LICENSE="GPL-3"
IUSE=""

S="${WORKDIR}"

DEPEND=""
RDEPEND="${DEPEND}
	app-emulation/wine
	"

src_install() {
	insinto /etc/xdg/menus/applications-merged/
	doins  "${FILESDIR}/menus/wine.menu" || die "doins menu failed"
	insinto /usr/share/desktop-directories/
	doins  "${FILESDIR}/desktop-directories/Wine.directory" || die "doins directory failed"
	domenu "${FILESDIR}"/applications/*.desktop || die "domenu *.desktop failed"
	insinto /usr/share/pixmaps/
	doins "${FILESDIR}"/icons/*.svg || die "doins pixmaps failed"
}
