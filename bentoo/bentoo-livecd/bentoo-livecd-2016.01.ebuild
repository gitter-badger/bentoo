# Copyright 1999-2017 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"

DESCRIPTION="things needed by bentoo for livecd only"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="arm amd64 x86"
IUSE="livecd"

S="${WORKDIR}"

DEPEND=""
RDEPEND="livecd? ( app-misc/livecd-tools
		virtual/eject
		sys-apps/hwsetup
		sys-block/disktype
		x11-misc/mkxf86config
		sys-apps/gentoo-functions
	)"

pkg_setup() {
	use !livecd && die "Failed safety check, please run 'emerge --depclean' and/or manually remove pentoo-livecd"
}

src_install() {
	#/usr/sbin
	newsbin "${FILESDIR}"/flushchanges-${PV} flushchanges
	newsbin "${FILESDIR}"/makemo-${PV} makemo

	newinitd "${FILESDIR}"/binary-driver-handler.initd-${PV} binary-driver-handler
}
