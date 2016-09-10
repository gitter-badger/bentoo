# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

EAPI="6"

inherit eutils autotools

DESCRIPTION="library for manipulating and storing storage volume encryption keys"
HOMEPAGE="https://fedorahosted.org/volume_key/"
SRC_URI="https://fedorahosted.org/releases/v/o/${PN}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sys-devel/autoconf:2.63"
RDEPEND="
	dev-libs/glib
	dev-libs/nss
	dev-libs/glib:2
	sys-devel/gettext
	sys-apps/util-linux"

src_prepare() {
	ipatch push . "${FILESDIR}"/volume_key-0.3.9-fips-crash.patch
	ipatch push . "${FILESDIR}"/volume_key-0.3.9-config.h.patch
	eapply_user
	eautoreconf
}
