# Copyright 1999-2017 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
DESCRIPTION="Collection of firefox extensions for application security auditing and assessment."
# HOMEPAGE="http://www.security-database.com/toolswatch/FireCAT-Firefox-Catalog-of,302.html https://prism-break.org/en/categories/gnu-linux/#web-browser-addons "
HOMEPAGE="http://www.firecat.fr/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="chromium firefox kde"

PDEPEND="
	chromium? (
		www-plugins/chrome-binary-plugins
	)
	firefox? (
		www-plugins/classic-theme-restorer
		www-plugins/decentraleyes
		www-plugins/disconnect
		www-plugins/exif-viewer
		www-plugins/firebug
		www-plugins/foxyproxy
		www-plugins/greasemonkey
		www-plugins/h264ify
		www-plugins/hackbar
		www-plugins/https-everywhere
		www-plugins/iconic-firefox-menu
		www-plugins/librejs
		www-plugins/live-http-headers
		www-plugins/menu-icons-plus
		www-plugins/mozplugger
		www-plugins/nimbus-screen-capture
		www-plugins/noscript
		www-plugins/password-reuse-visualizer
		www-plugins/privacy-badger
		www-plugins/pwgen
		www-plugins/random-agent-spoofer
		www-plugins/righttoclick
		www-plugins/s3download-statusbar
		www-plugins/s3google-translator
		www-plugins/s3menu-wizard
		www-plugins/saved-password-editor
		www-plugins/self-destructing-cookies
		www-plugins/session-manager
		www-plugins/showip
		www-plugins/show-password-field
		www-plugins/status-4-evar
		www-plugins/tree-style-tab
		www-plugins/ublock-origin
		www-plugins/unmht
		www-plugins/visual-hashing
		www-plugins/worldip
		www-plugins/youtube-center
	)
	kde? (
		kde-apps/konq-plugins
	)"
