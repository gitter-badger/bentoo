# Copyright 1999-2017 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
KEYWORDS="~amd64 ~arm ~x86"
DESCRIPTION="Bentoo gnome meta ebuild"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
SLOT="0"
LICENSE="GPL-3"
IUSE="accessibility +bluetooth +classic +cdr cups python evolution +extras handbrake +bijiben boxes builder california flashback +fonts +games geary +share +shotwell +todo +tracker"

RDEPEND="${DEPEND}
	bentoo/bentoo-xorg
	bentoo/bentoo-dm

	python? ( >=dev-python/pygobject-${PV}:3 )

	>=gnome-base/gnome-session-${PV}
	>=gnome-base/gnome-menus-3.13.3:3
	>=gnome-base/gnome-settings-daemon-${PV}[cups?]
	>=gnome-base/gnome-control-center-${PV}[cups?]

	>=app-crypt/gcr-3.20.0
	>=gnome-base/nautilus-${PV}
	>=gnome-base/gnome-keyring-3.20.0

	>=app-crypt/seahorse-3.20.0
	>=app-editors/gedit-${PV}
	>=app-text/evince-${PV}
	>=gnome-extra/gnome-contacts-${PV}
	>=media-gfx/eog-3.20.0
	>=media-video/totem-${PV}
	>=net-im/empathy-3.12.12
	>=x11-terms/gnome-terminal-${PV}

	>=gnome-extra/gnome-user-docs-${PV}
	>=gnome-extra/yelp-${PV}

	>=x11-themes/adwaita-icon-theme-${PV}
	>=x11-themes/gnome-themes-standard-${PV}

	bluetooth? ( >=net-wireless/gnome-bluetooth-3.20.0 )
	cdr? ( >=app-cdr/brasero-3.12.1 )

	!gnome-base/gnome-applets

	>=x11-wm/mutter-${PV}
	>=gnome-base/gnome-shell-${PV}[bluetooth?]
	>=gnome-extra/gnome-shell-frippery-${PV}

	>=x11-themes/gnome-backgrounds-${PV}
	x11-themes/sound-theme-freedesktop

	accessibility? (
		>=app-accessibility/at-spi2-atk-${PV}
		>=app-accessibility/at-spi2-core-${PV}
		>=app-accessibility/caribou-${PV}
		>=app-accessibility/orca-${PV}
		>=gnome-extra/mousetweaks-${PV} )
	classic? ( >=gnome-extra/gnome-shell-extensions-${PV} )
	evolution? (
		>=mail-client/evolution-${PV}
		>=gnome-extra/evolution-data-server-${PV}
	)
	handbrake? ( media-video/handbrake )
	extras? (
		>=app-admin/gnome-system-log-20160922
		>=app-arch/file-roller-${PV}
		>=app-dicts/gnome-dictionary-3.20.0
		>=gnome-base/dconf-editor-${PV}
		>=gnome-extra/gconf-editor-3
		>=gnome-extra/gnome-calculator-${PV}
		>=gnome-extra/gnome-calendar-${PV}
		>=gnome-extra/gnome-characters-${PV}
		>=gnome-extra/gnome-clocks-${PV}
		>=gnome-extra/gnome-getting-started-docs-${PV}
		>=gnome-extra/gnome-power-manager-${PV}
		>=gnome-extra/gnome-search-tool-3.6
		>=gnome-extra/gnome-system-monitor-${PV}
		>=gnome-extra/gnome-tweak-tool-${PV}
		>=gnome-extra/gnome-weather-3.20.0
		>=gnome-extra/gucharmap-${PV}:2.90
		>=gnome-extra/nautilus-sendto-3.8.4
		>=gnome-extra/sushi-3.21.91
		>=media-gfx/gnome-font-viewer-${PV}
		>=media-gfx/gnome-screenshot-${PV}
		>=media-sound/gnome-sound-recorder-3.21.92
		>=media-sound/sound-juicer-${PV}
		>=media-video/cheese-${PV}
		>=net-analyzer/gnome-nettool-3.8
		>=net-misc/vinagre-${PV}
		>=net-misc/vino-${PV}
		>=sci-geosciences/gnome-maps-${PV}
		>=sys-apps/baobab-${PV}
		>=sys-apps/gnome-disk-utility-${PV}
		>=app-editors/gedit-plugins-${PV}

		bijiben? ( >=app-misc/bijiben-3.21.2 )
		boxes? ( >=gnome-extra/gnome-boxes-${PV} )
		builder? ( >=gnome-extra/gnome-builder-3.18.0 )
		california? ( >=gnome-extra/california-0.4.0 )
		flashback? ( >=gnome-base/gnome-flashback-${PV} )
		fonts? (
			>=media-fonts/noto-20160305
			>=media-fonts/symbola-8.00
			>=media-fonts/unifont-8.0.01
		)
		games? (
			>=games-arcade/gnome-nibbles-${PV}
			>=games-arcade/gnome-robots-${PV}
			>=games-board/aisleriot-${PV}
			>=games-board/four-in-a-row-${PV}
			>=games-board/gnome-chess-${PV}
			>=games-board/gnome-mahjongg-${PV}
			>=games-board/gnome-mines-${PV}
			>=games-board/iagno-${PV}
			>=games-board/tali-${PV}
			>=games-puzzle/atomix-${PV}
			>=games-puzzle/five-or-more-${PV}
			>=games-puzzle/gnome2048-${PV}
			>=games-puzzle/gnome-klotski-${PV}
			>=games-puzzle/gnome-sudoku-${PV}
			>=games-puzzle/gnome-taquin-${PV}
			>=games-puzzle/gnome-tetravex-${PV}
			>=games-puzzle/hitori-${PV}
			>=games-puzzle/lightsoff-${PV}
			>=games-puzzle/quadrapassel-${PV}
			>=games-puzzle/swell-foop-${PV}
		)
		geary? ( >=mail-client/geary-0.11.2 )
		share? ( >=gnome-extra/gnome-user-share-3.18.1 )
		shotwell? ( >=media-gfx/shotwell-0.23.7 )
		todo? ( >=gnome-extra/gnome-todo-3.20.0 )
		tracker? (
			>=app-misc/tracker-1.10
			>=gnome-extra/gnome-documents-${PV}
			>=media-gfx/gnome-photos-${PV}
			>=media-sound/gnome-music-${PV}
		)
	)

"

DEPEND=""

PDEPEND=">=gnome-base/gvfs-1.30[udisks]"

pkg_postinst() {
	# Remember people where to find our project information
	elog "Please remember to look at https://wiki.gentoo.org/wiki/Project:GNOME"
	elog "for information about the project and documentation."
}
