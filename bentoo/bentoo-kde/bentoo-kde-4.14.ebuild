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

	<kde-apps/kate-4.14.50
	<kde-apps/kde4-l10n-4.14.50
	<kde-base/kdeplasma-addons-4.14.50

	<kde-apps/kcron-4.14.50
	<kde-apps/kdeadmin-meta-4.14.50
	<kde-apps/ksystemlog-4.14.50
	<kde-apps/kuser-4.14.50

	<kde-apps/kdeartwork-colorschemes-4.14.50
	<kde-apps/kdeartwork-desktopthemes-4.14.50
	<kde-apps/kdeartwork-emoticons-4.14.50
	<kde-apps/kdeartwork-iconthemes-4.14.50
	<kde-apps/kdeartwork-kscreensaver-4.14.50
	<kde-apps/kdeartwork-meta-4.14.50
	<kde-apps/kdeartwork-styles-4.14.50
	<kde-apps/kdeartwork-wallpapers-4.14.50
	<kde-apps/kdeartwork-weatherwallpapers-4.14.50

	<kde-apps/kdebase-meta-4.14.50
	<kde-apps/dolphin-4.14.50
	<kde-apps/kdepasswd-4.14.50
	<kde-apps/kdialog-4.14.50
	<kde-apps/keditbookmarks-4.14.50
	<kde-apps/kfind-4.14.50
	<kde-apps/kfmclient-4.14.50
	<kde-apps/konqueror-4.14.50
	<kde-apps/konq-plugins-4.14.50
	<kde-apps/konsole-4.14.50
	<kde-apps/kwrite-4.14.50
	<kde-apps/libkonq-4.14.50
	<kde-apps/nsplugins-4.14.50
	<kde-apps/plasma-apps-4.14.50
	<kde-apps/attica-4.14.50
	<kde-apps/drkonqi-4.14.50
	<kde-apps/kcmshell-4.14.50
	<kde-apps/kcontrol-4.14.50
	<kde-apps/kdebase-data-4.14.50
	<kde-apps/kdebase-desktoptheme-4.14.50
	<kde-apps/kdebase-kioslaves-4.14.50
	<kde-apps/kdebase-menu-4.14.50
	<kde-apps/kdebase-menu-icons-4.14.50
	<kde-apps/kdebase-runtime-meta-4.14.50
	<kde-apps/kdebugdialog-4.14.50
	<kde-apps/kdesu-4.14.50
	<kde-apps/kde-base-artwork-4.14.50
	<kde-apps/kde-wallpapers-4.14.50
	<kde-apps/kdontchangethehostname-4.14.50
	<kde-apps/keditfiletype-4.14.50
	<kde-apps/kfile-4.14.50
	<kde-apps/kglobalaccel-4.14.50
	<kde-base/khelpcenter-4.14.50
	<kde-apps/kiconfinder-4.14.50
	<kde-apps/kimgio-4.14.50
	<kde-apps/kioclient-4.14.50
	<kde-apps/kmimetypefinder-4.14.50
	<kde-apps/knetattach-4.14.50
	<kde-apps/knewstuff-4.14.50
	<kde-apps/knotify-4.14.50
	<kde-apps/kpasswdserver-4.14.50
	<kde-apps/kquitapp-4.14.50
	<kde-apps/kreadconfig-4.14.50
	<kde-apps/kstart-4.14.50
	<kde-apps/ktimezoned-4.14.50
	<kde-apps/ktraderclient-4.14.50
	<kde-apps/kuiserver-4.14.50
	<kde-apps/kurifilter-plugins-4.14.50
	<kde-apps/kwalletd-4.14.50
	<kde-apps/phonon-kde-4.14.50
	<kde-apps/plasma-runtime-4.14.50
	<kde-apps/renamedlg-plugins-4.14.50
	<kde-apps/solid-runtime-4.14.50
	<kde-base/freespacenotifier-4.11.50
	<kde-base/kcheckpass-4.11.50
	<kde-base/kcminit-4.11.50
	<kde-base/kdebase-cursors-4.11.50
	<kde-base/kdebase-startkde-4.11.50
	<kde-base/kdm-4.11.50
	<kde-base/kephal-4.11.50
	<kde-base/khotkeys-4.11.50
	<kde-base/kinfocenter-4.11.50
	<kde-base/klipper-4.11.50
	<kde-base/kmenuedit-4.11.50
	<kde-base/krunner-4.11.50
	<kde-base/kscreensaver-4.11.50
	<kde-base/ksmserver-4.11.50
	<kde-base/ksplash-4.11.50
	<kde-base/kstartupconfig-4.11.50
	<kde-base/kstyles-4.11.50
	<kde-base/ksysguard-4.11.50
	<kde-base/ksystraycmd-4.11.50
	<kde-base/kwin-4.11.50
	<kde-base/kwrited-4.11.50
	<kde-base/libkgreeter-4.11.50
	<kde-base/libkworkspace-4.11.50
	<kde-base/liboxygenstyle-4.11.50
	<kde-base/libplasmaclock-4.11.50
	<kde-base/libplasmagenericshell-4.11.50
	<kde-base/libtaskmanager-4.11.50
	<kde-base/plasma-workspace-4.11.50
	<kde-base/powerdevil-4.11.50
	<kde-base/qguiplatformplugin_kde-4.11.50
	<kde-base/solid-actions-kcm-4.11.50
	<kde-base/systemsettings-4.11.50

	<kde-apps/kpat-4.14.50

	<kde-apps/gwenview-4.14.50
	<kde-apps/kamera-4.14.50
	<kde-apps/kcolorchooser-4.14.50
	<kde-apps/kdegraphics-meta-4.14.50
	<kde-apps/kdegraphics-mobipocket-4.14.50
	<kde-apps/kgamma-4.14.50
	<kde-apps/kolourpaint-4.14.50
	<kde-apps/kruler-4.14.50
	<kde-apps/ksnapshot-4.14.50
	<kde-apps/libkdcraw-4.14.50
	<kde-apps/libkexiv2-4.14.50
	<kde-apps/libkipi-4.14.50
	<kde-apps/okular-4.14.50
	<kde-apps/svgpart-4.14.50
	<kde-apps/thumbnailers-4.14.50

	<kde-base/baloo-4.14.50
	<kde-apps/baloo-widgets-4.14.50
	<kde-base/kactivities-4.13.50
	<kde-base/kde-env-4.14.50
	<kde-base/kdelibs-4.14.50
	<kde-base/kfilemetadata-4.14.50
	<kde-base/kdepimlibs-4.14.50
	<kde-base/katepart-4.14.50
	<kde-frameworks/oxygen-icons-4.14.50

	<kde-apps/dragon-4.14.50
	<kde-apps/ffmpegthumbs-4.14.50
	<kde-apps/juk-4.14.50
	<kde-apps/audiocd-kio-4.14.50
	<kde-apps/kdemultimedia-meta-4.14.50
	<kde-apps/kmix-4.14.50
	<kde-apps/kscd-4.14.50
	<kde-apps/libkcddb-4.14.50
	<kde-apps/libkcompactdisc-4.14.50
	<kde-apps/mplayerthumbs-4.14.50
	media-sound/clementine

	<kde-apps/kdenetwork-filesharing-4.14.50
	<kde-apps/kdenetwork-meta-4.14.50
	<kde-apps/kget-4.14.50
	<kde-apps/kopete-4.14.50
	<kde-apps/krdc-4.14.50
	<kde-apps/krfb-4.14.50
	<kde-apps/zeroconf-ioslave-4.14.50
	kde-misc/plasma-nm
	net-wireless/bluedevil

	<kde-base/akonadiconsole-4.14.50
	<kde-base/akregator-4.14.50
	<kde-base/blogilo-4.14.50
	<kde-base/calendarjanitor-4.14.50
	<kde-base/kabcclient-4.14.50
	<kde-base/kaddressbook-4.14.50
	<kde-base/kalarm-4.14.50
	<kde-base/kdepim-common-libs-4.14.50
	<kde-base/kdepim-icons-4.14.50
	<kde-base/kdepim-kresources-4.14.50
	<kde-base/kdepim-l10n-4.14.50
	<kde-base/kdepim-meta-4.14.50
	<kde-base/kdepim-runtime-4.14.50
	<kde-base/kjots-4.14.50
	<kde-base/kleopatra-4.14.50
	<kde-base/kmail-4.14.50
	<kde-base/knode-4.14.50
	<kde-base/knotes-4.14.50
	<kde-base/konsolekalendar-4.14.50
	<kde-base/kontact-4.14.50
	<kde-base/korganizer-4.14.50
	<kde-base/ktimetracker-4.14.50
	<kde-base/ktnef-4.14.50

	<kde-apps/ark-4.14.50
	<kde-apps/filelight-4.14.50
	<kde-apps/kcalc-4.14.50
	<kde-apps/kcharselect-4.14.50
	<kde-apps/kdeutils-meta-4.14.50
	<kde-apps/kdf-4.14.50
	<kde-apps/kgpg-4.14.50
	<kde-apps/ktimer-4.14.50
	<kde-apps/kwalletmanager-4.14.50
	<kde-apps/superkaramba-4.14.50
	<kde-apps/sweeper-4.14.50
"

PDEPEND=""

pkg_postinst() {
	# Remember people where to find our project information
	elog "Please remember to look at https://wiki.gentoo.org/wiki/Project:KDE"
	elog "for information about the project and documentation."
}
