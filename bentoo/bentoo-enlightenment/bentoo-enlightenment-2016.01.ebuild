# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
KEYWORDS="amd64 arm x86"
DESCRIPTION="Bentoo enlightenment meta ebuild"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
SLOT="0"
LICENSE="GPL-3"
IUSE="bluetooth network"

DEPEND=""
RDEPEND="${DEPEND}
	bentoo/bentoo-xorg
	bentoo/bentoo-dm

	x11-wm/enlightenment:0.17
	x11-terms/terminology
	bluetooth? ( =net-wireless/bluez-4* )
        network? (
                net-misc/connman
                >=net-misc/econnman-1.1
        )
"

PDEPEND=""

pkg_postinst() {
	# Remember people where to find our project information
	elog "Please remember to look at https://wiki.gentoo.org/wiki/Enlightenment"
	elog "for information about the project and documentation."
}
