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

DESCRIPTION="Portage's intelligent bashrc."
HOMEPAGE="https://bitbucket.org/redeyeteam/ibashrc"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sys-apps/portage
	sys-devel/ipatch"

if [[ ${PV} == "9999" ]] ; then
	S="${WORKDIR}/${P}"
else
	MY_COMMIT="2d12c6917a49"
	S="${WORKDIR}/redeyeteam-${PN}-${MY_COMMIT}"
fi

src_install() {
	test -d "${D}/etc/portage" >/dev/null 2>&1 && cd "${D}/etc/portage" || mkdir -p "${D}/etc/portage"; cd "${D}/etc/portage"
	cp "${S}/ibashrc" "${D}/etc/portage/ibashrc" || die
}

pkg_postinst() {
	echo
	einfo
	einfo "In order to enable ibashrc go to /etc/portage and do:"
	einfo "ln -s ibashrc bashrc"
	einfo
	echo
}
