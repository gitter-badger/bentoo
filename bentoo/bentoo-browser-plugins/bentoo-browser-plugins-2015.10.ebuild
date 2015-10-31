# Copyright 1999-2015 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

EAPI=5
DESCRIPTION="Collection of firefox extensions for application security auditing and assessment."
# HOMEPAGE="http://www.security-database.com/toolswatch/FireCAT-Firefox-Catalog-of,302.html"
HOMEPAGE="http://www.firecat.fr/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="firefox"

PDEPEND="
	firefox? (
		www-plugins/exif_viewer
		www-plugins/firebug
		www-plugins/foxyproxy
		www-plugins/greasemonkey
		www-plugins/hackbar
		www-plugins/httpfox
		www-plugins/https-everywhere
		www-plugins/live-http-headers
		www-plugins/noscript
		www-plugins/privacy_badger
		www-plugins/private_tab
		www-plugins/proxy_selector
		www-plugins/referrer-control
		www-plugins/s3download-statusbar
		www-plugins/session-manager
		www-plugins/show-password-field
		www-plugins/ublock-origin
		www-plugins/user-agent-switcher
		www-plugins/worldip

		www-plugins/youtube_center
	)"

#		www-plugins/policeman
#		www-plugins/showip
#		www-plugins/password_exporter
#		www-plugins/quick_locale_switcher
#		www-plugins/sql-inject-me
#		www-plugins/xss-me
