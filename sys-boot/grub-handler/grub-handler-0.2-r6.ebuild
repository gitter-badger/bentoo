# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $


EAPI="6"
DESCRIPTION="Bentoo Linux GRUB utilities"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install () {
	exeinto /usr/sbin
	doexe "${FILESDIR}/${PN}"
}
