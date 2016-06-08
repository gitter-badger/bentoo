# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

EAPI=6
inherit transmission-2.92

DESCRIPTION="A BitTorrent client (meta package)"
#HOMEPAGE="http://www.transmissionbt.com/"
SRC_URI=""

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ayatana gtk libressl lightweight systemd qt4 qt5 xfs"

RDEPEND="
	~net-p2p/transmission-base-${PV}[lightweight=,xfs=,libressl=]
	|| (
		~net-p2p/transmission-gtk-${PV}[ayatana=,libressl=]
		~net-p2p/transmission-qt5-${PV}[libressl=]
		~net-p2p/transmission-qt4-${PV}[libressl=]
	)
"
