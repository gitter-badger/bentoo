# Copyright 1999-2015 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

EAPI=5
KEYWORDS="amd64 arm x86"
DESCRIPTION="Bentoo gnome meta ebuild"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
SLOT="0"
LICENSE="GPL-3"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	bentoo/bentoo-xorg

	<kde-apps/ark-4.14.50
	<kde-apps/dolphin-4.14.50
	<kde-apps/dolphin-plugins-4.14.50
	<kde-apps/filelight-4.14.50
	<kde-apps/gwenview-4.14.50
	<kde-apps/kamera-4.14.50
	<kde-apps/kate-4.14.50
	<kde-apps/kcalc-4.14.50
	<kde-apps/kcalc-4.14.50
	<kde-apps/kde4-l10n-4.14.50
	<kde-apps/kdialog-4.14.50
	<kde-apps/kgpg-4.14.50
	<kde-apps/kmix-4.14.50
	<kde-apps/konsole-4.14.50
	<kde-apps/kopete-4.14.50
	<kde-apps/kpat-4.14.50
	<kde-apps/ksystemlog-4.14.50
	<kde-apps/kwalletmanager-4.14.50
	<kde-apps/okular-4.14.50
	<kde-apps/plasma-apps-4.14.50
	<kde-base/kdebase-startkde-4.14.50
	<kde-base/kdeplasma-addons-4.14.50
	<kde-base/kdm-4.14.50
	<kde-base/kmail-4.14.50
	<kde-misc/kdiff3-4.14.50
	kde-misc/plasma-nm
	net-wireless/bluedevil
"
	
PDEPEND=""

pkg_postinst() {
	# Remember people where to find our project information
	elog "Please remember to look at https://wiki.gentoo.org/wiki/Project:KDE"
	elog "for information about the project and documentation."
}
