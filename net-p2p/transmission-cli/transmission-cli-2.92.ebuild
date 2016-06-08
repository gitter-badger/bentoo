# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

EAPI=6
inherit transmission-2.92

DESCRIPTION="A Fast, Easy and Free BitTorrent client - command line (CLI) version"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install() {
	dobin cli/transmission-cli
	doman cli/transmission-cli.1
}
