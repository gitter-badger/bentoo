# Copyright 1999-2017 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
DESCRIPTION="Bentoo browser meta ebuild"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
KEYWORDS="amd64 arm x86"
SLOT="0"
LICENSE="GPL-3"
IUSE="chromium +firefox gnome qupzilla kde"

DEPEND=""
RDEPEND="${DEPEND}
	www-client/lynx
	chromium? (
		www-client/chromium
		bentoo/bentoo-browser-plugins[chromium]
	)
	firefox? (
		|| ( www-client/firefox www-client/firefox-bin )
		bentoo/bentoo-browser-plugins[firefox]
	)
	gnome? (
		www-client/epiphany
	)
	qupzilla? (
		www-client/qupzilla
	)
	kde? (
		kde-apps/konqueror
		bentoo/bentoo-browser-plugins[kde]
	)
	"
