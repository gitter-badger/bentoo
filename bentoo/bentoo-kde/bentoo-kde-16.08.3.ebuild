# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
KEYWORDS="amd64 arm x86"
DESCRIPTION="Bentoo kde meta ebuild"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
SLOT="0"
LICENSE="GPL-3"
IUSE="addons bluetooth filelight kamera kgpg kdialog kdepim kmix kpat krusader ksystemlog kwalletmanager kwalletpam networkmanager okular telepathy touchpad"

DEPEND=""
RDEPEND="${DEPEND}
	bentoo/bentoo-xorg
	bentoo/bentoo-dm

	<kde-apps/ark-16.12.50
	<kde-apps/dolphin-16.12.50
	<kde-apps/dolphin-plugins-16.12.50
	<kde-apps/gwenview-16.12.50
	<kde-apps/kate-16.12.50
	<kde-apps/kcalc-16.12.50
	<kde-apps/kde-l10n-16.12.50
	<kde-apps/kompare-16.12.50
	<kde-apps/konsole-16.12.50

	<kde-apps/spectacle-16.12.50
	<kde-plasma/plasma-desktop-16.12.50
	<kde-plasma/systemsettings-16.12.50

	addons? ( <kde-plasma/kdeplasma-addons-16.12.50 )
	bluetooth? ( <kde-plasma/bluedevil-16.12.50 )
	filelight? ( <kde-apps/filelight-16.12.50 )
	kamera? ( <kde-apps/kamera-16.12.50 )
	kgpg? ( <kde-apps/kgpg-16.12.50 )
	kdialog? ( <kde-apps/kdialog-16.12.50 )
	kdepim? ( <kde-apps/kdepim-16.12.50 )
	kmix? ( <kde-apps/kmix-16.12.50 )
	kpat? ( <kde-apps/kpat-16.12.50 )
	krusader? ( =kde-misc/krusader-9999 )
	ksystemlog? ( <kde-apps/ksystemlog-16.12.50 )
	kwalletmanager? ( <kde-apps/kwalletmanager-16.12.50 )
	kwalletpam? ( <kde-plasma/kwallet-pam-16.12.50
					x11-misc/sddm[pam] )
	networkmanager? ( <kde-plasma/plasma-nm-16.12.50 )
	okular? ( <kde-apps/okular-16.12.50 )
	telepathy? ( <kde-apps/plasma-telepathy-meta-16.12.50 )
	touchpad? ( kde-plasma/plasma-desktop[touchpad] )
"

# <kde-apps/plasma-apps-16.12.50

PDEPEND=""

pkg_postinst() {
	# Remember people where to find our project information
	elog "Please remember to look at https://wiki.gentoo.org/wiki/Project:KDE"
	elog "for information about the project and documentation."
}
