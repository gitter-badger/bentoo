# Copyright 1999-2015 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

EAPI=5
KEYWORDS="amd64 arm x86"
DESCRIPTION="Bentoo rxvt meta ebuild"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
SLOT="0"
LICENSE="GPL-3"
IUSE=""

S="${WORKDIR}"

DEPEND=""
RDEPEND="${DEPEND}
	x11-terms/rxvt-unicode
	"

src_install() {
	exeinto /root
	newins "${FILESDIR}"/Xresources .Xresources || die "doins Xresources failed"
}
