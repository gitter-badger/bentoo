# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
KEYWORDS="amd64 arm x86"
DESCRIPTION="Bentoo xfce meta ebuild"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
SLOT="0"
LICENSE="GPL-3"
IUSE="bluetooth +cdr pulseaudio"

DEPEND=""
RDEPEND="${DEPEND}
	bentoo/bentoo-xorg
	bentoo/bentoo-dm

	xfce-base/xfce4-meta
	cdr? ( app-cdr/xfburn )
	pulseaudio? ( xfce-extra/xfce4-volumed-pulse )
	|| ( gnome-extra/nm-applet net-misc/wicd net-wireless/wifi-radar )
	app-editors/leafpad
	app-text/evince
	app-text/mupdf
	media-gfx/geeqie
	x11-terms/xfce4-terminal
	x11-themes/tango-icon-theme
	xfce-base/thunar
	xfce-extra/xfce4-battery-plugin
	xfce-extra/thunar-archive-plugin
	xfce-extra/thunar-vcs-plugin
	xfce-extra/thunar-volman
	xfce-extra/tumbler
	pulseaudio? ( xfce-extra/xfce4-pulseaudio-plugin )
	xfce-extra/xfce4-notifyd
	xfce-extra/xfce4-power-manager
	xfce-extra/xfce4-screenshooter
	xfce-extra/xfce4-xkb-plugin
	bluetooth? ( net-wireless/blueman[thunar] )
"

PDEPEND=""

pkg_postinst() {
	# Remember people where to find our project information
	elog "Please remember to look at https://wiki.gentoo.org/wiki/Xfce"
	elog "for information about the project and documentation."
}
