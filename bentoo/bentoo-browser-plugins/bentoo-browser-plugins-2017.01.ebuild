# Copyright 1999-2017 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
DESCRIPTION="Browser plugins"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
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
		www-plugins/firebug
		www-plugins/foxyproxy
		www-plugins/greasemonkey
		www-plugins/https-everywhere
		www-plugins/iconic-firefox-menu
		www-plugins/menu-icons-plus
		www-plugins/noscript
		www-plugins/password-reuse-visualizer
		www-plugins/pwgen
		www-plugins/random-agent-spoofer
		www-plugins/s3download-statusbar
		www-plugins/saved-password-editor
		www-plugins/self-destructing-cookies
		www-plugins/session-manager
		www-plugins/showip
		www-plugins/show-password-field
		www-plugins/status-4-evar
		www-plugins/tree-style-tab
		www-plugins/ublock-origin
		www-plugins/visual-hashing
		www-plugins/worldip
		www-plugins/mozplugger
	)
	kde? (
		kde-apps/konq-plugins
	)"
