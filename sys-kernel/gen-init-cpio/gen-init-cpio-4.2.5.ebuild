# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"

DESCRIPTION="Program to compress initramfs images"
HOMEPAGE="http://www.kernel.org/"
SRC_URI=""

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="sys-libs/glibc"

src_unpack() {
	mkdir "${S}"
	cp "${FILESDIR}"/{gen_init_cpio.c,Makefile} "${S}"

	sed -i \
		-e 's|\/usr\/bin\/||g' \
		-e 's|\/bin\/||g' \
		"${S}"/Makefile || die
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
}
