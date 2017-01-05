# Copyright 1999-2017 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
KEYWORDS="amd64 arm x86"
DESCRIPTION="Bentoo kde meta ebuild"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
SLOT="0"
LICENSE="GPL-3"
IUSE="addons bluetooth filelight kamera kdepim kmix kpat krusader ksystemlog kwalletmanager kwalletpam networkmanager telepathy touchpad"

DEPEND=""
RDEPEND="${DEPEND}
	bentoo/bentoo-xorg
	bentoo/bentoo-dm

	<kde-apps/ark-15.12.50
	<kde-apps/dolphin-15.12.50
	<kde-apps/dolphin-plugins-15.12.50
	<kde-apps/gwenview-15.12.50
	<kde-apps/kate-15.12.50
	<kde-apps/kcalc-15.12.50
	<kde-apps/kde-l10n-15.12.50
	<kde-apps/kompare-15.12.50
	<kde-apps/konsole-15.12.50
	<kde-apps/spectacle-15.12.50
	<kde-plasma/plasma-desktop-15.12.50
	<kde-plasma/systemsettings-15.12.50
	addons? ( <kde-plasma/kdeplasma-addons-15.12.50 )
	filelight? ( <kde-apps/filelight-15.12.50 )
	kamera? ( <kde-apps/kamera-15.12.50 )
	kdepim? ( <kde-apps/kdepim-15.12.50 )
	kmix? ( <kde-apps/kmix-15.12.50 )
	kpat? ( <kde-apps/kpat-15.12.50 )
	krusader? ( =kde-misc/krusader-9999 )
	ksystemlog? ( <kde-apps/ksystemlog-15.12.50 )
	kwalletmanager? ( <kde-apps/kwalletmanager-15.12.50 )
	kwalletpam? ( <kde-plasma/kwallet-pam-15.12.50
					x11-misc/sddm[pam] )
	telepathy? ( <kde-apps/plasma-telepathy-meta-15.12.50 )
	bluetooth? ( <kde-plasma/bluedevil-15.12.50 )
	networkmanager? ( <kde-plasma/plasma-nm-15.12.50 )
	touchpad? ( kde-plasma/plasma-desktop[touchpad] )
"
#	kde-4 dep-s:
#	<kde-apps/kdialog-15.12.50
#	<kde-apps/kgpg-15.12.50
#	<kde-apps/okular-15.12.50
#	<kde-apps/plasma-apps-15.12.50

PDEPEND=""

pkg_postinst() {
	# Remember people where to find our project information
	elog "Please remember to look at https://wiki.gentoo.org/wiki/Project:KDE"
	elog "for information about the project and documentation."
}
