# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

EAPI=5
KEYWORDS="~amd64 ~arm ~x86"
DESCRIPTION="Bentoo kde meta ebuild"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
SLOT="0"
LICENSE="GPL-3"
IUSE="bluetooth networkmanager touchpad"

DEPEND=""
RDEPEND="${DEPEND}
	bentoo/bentoo-xorg

	<kde-apps/ark-15.12.50
	<kde-apps/dolphin-15.12.50
	<kde-apps/dolphin-plugins-15.12.50
	<kde-apps/filelight-15.12.50
	<kde-apps/gwenview-15.12.50
	<kde-apps/kamera-15.12.50
	<kde-apps/kate-15.12.50
	<kde-apps/kcalc-15.12.50
	<kde-apps/kde-l10n-15.12.50
	<kde-apps/kdepim-15.12.50
	<kde-apps/kmix-15.12.50
	<kde-apps/kompare-15.12.50
	<kde-apps/konsole-15.12.50
	<kde-apps/kpat-15.12.50
	<kde-apps/ksystemlog-15.12.50
	<kde-apps/kwalletmanager-15.12.50
	<kde-apps/plasma-telepathy-meta-15.12.50
	<kde-plasma/kdeplasma-addons-15.12.50
	<kde-plasma/plasma-desktop-15.12.50
	<kde-plasma/sddm-kcm-15.12.50
	<kde-plasma/systemsettings-15.12.50
	<x11-misc/sddm-0.14.50
	bluetooth? ( <kde-plasma/bluedevil-15.12.50 )
	networkmanager? ( <kde-plasma/plasma-nm-15.12.50 )
	touchpad? ( kde-plasma/plasma-desktop[touchpad] )
"
#	kde-4 dep-s:
#	<kde-apps/plasma-apps-15.12.50
#	<kde-apps/kdialog-15.12.50
#	<kde-apps/ksnapshot-15.12.50
#	<kde-apps/kgpg-15.12.50
#	<kde-apps/okular-15.12.50

PDEPEND=""

pkg_postinst() {
	# Remember people where to find our project information
	elog "Please remember to look at https://wiki.gentoo.org/wiki/Project:KDE"
	elog "for information about the project and documentation."
}
