# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://bitbucket.org/redeyeteam/${PN}.git"
else
	SRC_URI="https://bitbucket.org/redeyeteam/${PN}/get/${PV}.tar.bz2 -> ${PN}-${PV}.tar.bz2"
fi

DESCRIPTION="Intelligent patch wrapper."
HOMEPAGE="https://bitbucket.org/redeyeteam/ipatch"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sys-apps/coreutils
	sys-apps/file
	sys-devel/patch
	app-arch/bzip2
	app-arch/gzip
	app-arch/lrzip
	app-arch/unzip
	app-arch/xz-utils"

if [[ ${PV} == "9999" ]] ; then
	S="${WORKDIR}/${P}"
else
	MY_COMMIT="f176042edc30"
	S="${WORKDIR}/redeyeteam-${PN}-${MY_COMMIT}"
fi

src_install() {
	dobin ipatch || die "dobin failed"
	insinto /usr/share/man/man1
	doins ipatch.1 || die "doins failed"
}
