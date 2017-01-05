# Copyright 1999-2017 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
PYTHON_COMPAT=( python3_4 )
inherit python-single-r1 autotools eutils

DESCRIPTION="A library for manipulating block devices."
HOMEPAGE="https://github.com/rhinstaller/libblockdev"
if [[ ${PV} == 9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/j-g-/libblockdev.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/rhinstaller/${PN}/archive/${P}-1.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${P}-1"
	KEYWORDS="~amd64"
fi

LICENSE="LGPL-2.1+"
SLOT="1"
IUSE="+doc +introspection"

DEPEND=""

RDEPEND="${DEPEND}
	doc? ( >=dev-util/gtk-doc-1 )
	>=dev-libs/glib-2.42.2:2
	>=dev-libs/nss-3.18.0
	>=dev-libs/volume_key-0.3.9
	>=dev-libs/nss-3.18
	introspection? ( dev-libs/gobject-introspection )
	sys-fs/lvm2
	sys-fs/dmraid
	>=sys-fs/cryptsetup-1.6.7
	>=sys-apps/util-linux-2.27
	sys-libs/libbytesize
	>=sys-apps/kmod-19
	>=virtual/libudev-215"

src_prepare() {
	ipatch push . "${FILESDIR}/libblockdev-1.9-cast_numbers.patch"
	eapply_user
	eautoreconf
}

src_configure() {
	local myconf=""
	econf \
	$(use_enable doc gtk-doc) \
	$(use_enable introspection introspection)
	LDFLAGS="-L${EPREFIX}/lib/" econf $myconf
}
