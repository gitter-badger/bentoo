# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64 ppc"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_unpack () {
        cd "${WORKDIR}"
        cp "${FILESDIR}"/gpu-configuration . -p
}

src_install () {
	cd "${WORKDIR}"
	exeinto /sbin/
	doexe gpu-configuration
}
