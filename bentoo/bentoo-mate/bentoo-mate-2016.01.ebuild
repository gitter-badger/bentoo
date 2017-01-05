# Copyright 1999-2017 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
KEYWORDS="amd64 arm x86"
DESCRIPTION="Bentoo mate meta ebuild"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
SLOT="0"
LICENSE="GPL-3"
IUSE="+cdr pulseaudio"

DEPEND=""
RDEPEND="${DEPEND}
	bentoo/bentoo-xorg
	bentoo/bentoo-dm

	mate-base/mate
	|| ( gnome-extra/nm-applet net-misc/wicd net-wireless/wifi-radar )
	x11-misc/mate-notification-daemon
"

PDEPEND=""

pkg_postinst() {
	# Remember people where to find our project information
	elog "Please remember to look at https://wiki.gentoo.org/wiki/Mate"
	elog "for information about the project and documentation."
}
