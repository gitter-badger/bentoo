# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
PYTHON_COMPAT=( python3_4 python3_5 python3_6 )
inherit python-single-r1 autotools eutils

DESCRIPTION="A tiny library providing a C class for working with arbitrary big sizes in bytes"
HOMEPAGE="https://github.com/rhinstaller/libbytesize"
if [[ ${PV} == 9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rhinstaller/libbytesize.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/rhinstaller/${PN}/archive/${P}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${P}"
#	KEYWORDS="~amd64"
	KEYWORDS=""
fi

LICENSE="LGPL-2.1+"
SLOT="1"
IUSE="doc"

DEPEND="${PYTHON_DEPS}"

RDEPEND="${DEPEND}
	dev-libs/gmp
	dev-libs/mpfr
	dev-libs/libpcre
	sys-devel/gettext
	doc? ( >=dev-util/gtk-doc-1 )"

src_prepare() {
	ipatch push . "${FILESDIR}/libbytesize-0.9-prefix.patch"
	eapply_user
	eautoreconf
}

src_configure() {
	local myconf=""
	econf \
	$(use_enable doc gtk-doc) \
	LDFLAGS="-L${EPREFIX}/lib/" econf $myconf
}
