# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

EAPI="6"
KEYWORDS="~amd64 ~arm ~x86"
DESCRIPTION="Bentoo gnome meta ebuild"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
SLOT="0"
LICENSE="GPL-3"
IUSE="accessibility +bluetooth +classic +cdr cups python +extras +games +share +shotwell +tracker"

DEPEND=""
RDEPEND="${DEPEND}
	bentoo/bentoo-xorg

	python? ( >=dev-python/pygobject-${PV}:3 )

	>=gnome-base/gnome-session-${PV}
	>=gnome-base/gnome-menus-3.10.1:3
	>=gnome-base/gnome-settings-daemon-${PV}[cups?]
	>=gnome-base/gnome-control-center-${PV}[cups?]

	>=app-crypt/gcr-${PV}
	>=gnome-base/nautilus-${PV}
	>=gnome-base/gnome-keyring-${PV}
	>=gnome-extra/evolution-data-server-${PV}

	>=app-crypt/seahorse-${PV}
	>=app-editors/gedit-${PV}
	>=app-text/evince-${PV}
	>=gnome-extra/gnome-contacts-${PV}
	>=media-gfx/eog-${PV}
	>=media-video/totem-${PV}
	>=net-im/empathy-3.12.10
	>=x11-terms/gnome-terminal-${PV}

	>=gnome-extra/gnome-user-docs-${PV}
	>=gnome-extra/yelp-${PV}

	>=x11-themes/adwaita-icon-theme-${PV}
	>=x11-themes/gnome-themes-standard-${PV}

	bluetooth? ( >=net-wireless/gnome-bluetooth-${PV} )
	cdr? ( >=app-cdr/brasero-3.12.1 )

	!gnome-base/gnome-applets

	>=gnome-base/gdm-${PV}

	>=x11-wm/mutter-${PV}
	>=gnome-base/gnome-shell-${PV}[bluetooth?]

	>=x11-themes/gnome-backgrounds-${PV}
	x11-themes/sound-theme-freedesktop

	accessibility? (
		>=app-accessibility/at-spi2-atk-${PV}
		>=app-accessibility/at-spi2-core-${PV}
		>=app-accessibility/caribou-0.4.18
		>=app-accessibility/orca-${PV}
		>=gnome-extra/mousetweaks-3.12.0 )
	classic? ( >=gnome-extra/gnome-shell-extensions-${PV} )
	extras? (
		>=gnome-base/gnome-core-libs-${PV}

		>=app-admin/gnome-system-log-3.9.90
		>=app-arch/file-roller-${PV}
		>=app-dicts/gnome-dictionary-${PV}
		>=gnome-base/dconf-editor-${PV}
		>=gnome-extra/gconf-editor-3
		>=gnome-extra/gnome-calculator-${PV}
		>=gnome-extra/gnome-power-manager-${PV}
		>=gnome-extra/gnome-search-tool-3.6
		>=gnome-extra/gnome-system-monitor-${PV}
		>=gnome-extra/gnome-tweak-tool-${PV}
		>=gnome-extra/gnome-weather-${PV}
		>=gnome-extra/gucharmap-${PV}:2.90
		>=gnome-extra/nautilus-sendto-3.8.2
		>=gnome-extra/sushi-${PV}
		>=mail-client/evolution-${PV}
		>=media-gfx/gnome-font-viewer-${PV}
		>=media-gfx/gnome-screenshot-${PV}
		>=media-sound/sound-juicer-${PV}
		>=media-video/cheese-${PV}
		>=net-analyzer/gnome-nettool-3.8
		>=net-misc/vinagre-${PV}
		>=net-misc/vino-${PV}
		>=sys-apps/baobab-${PV}
		>=sys-apps/gnome-disk-utility-${PV}

		games? (
			>=games-arcade/gnome-nibbles-${PV}
			>=games-arcade/gnome-robots-${PV}
			>=games-board/four-in-a-row-${PV}
			>=games-board/gnome-chess-${PV}
			>=games-board/gnome-mahjongg-${PV}
			>=games-board/gnome-mines-${PV}
			>=games-board/iagno-${PV}
			>=games-board/tali-${PV}
			>=games-puzzle/five-or-more-${PV}
			>=games-puzzle/gnome-klotski-${PV}
			>=games-puzzle/gnome-sudoku-${PV}
			>=games-puzzle/gnome-taquin-${PV}
			>=games-puzzle/gnome-tetravex-${PV}
			>=games-puzzle/hitori-${PV}
			>=games-puzzle/lightsoff-${PV}
			>=games-puzzle/quadrapassel-${PV}
			>=games-puzzle/swell-foop-${PV} )
		share? ( >=gnome-extra/gnome-user-share-3.14 )
		shotwell? ( >=media-gfx/shotwell-0.22 )
		tracker? (
			>=app-misc/tracker-1.6
			>=media-gfx/gnome-photos-${PV}
			>=media-sound/gnome-music-${PV} ) )
"

PDEPEND=">=gnome-base/gvfs-1.24[udisks]"

pkg_postinst() {
	# Remember people where to find our project information
	elog "Please remember to look at https://wiki.gentoo.org/wiki/Project:GNOME"
	elog "for information about the project and documentation."
}
