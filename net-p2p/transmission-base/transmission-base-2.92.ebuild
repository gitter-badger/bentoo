# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

EAPI=6
inherit transmission-2.92

DESCRIPTION="A Fast, Easy and Free BitTorrent client - base files"
KEYWORDS="~amd64 ~x86"
IUSE="lightweight xfs"

DEPEND="xfs? ( sys-fs/xfsprogs )"

DOCS="AUTHORS NEWS"

src_install() {
	default
	rm "${ED}"/usr/share/${MY_PN}/web/LICENSE || die
	dolib.a "${S}/libtransmission/libtransmission.a"
}
