# Copyright 1999-2015 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

EAPI=5
DESCRIPTION="Bentoo meta ebuild to install all apps"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
KEYWORDS="amd64 arm x86"
SLOT="0"
LICENSE="GPL-3"
IUSE="+gnome +mobile"

DEPEND=""

RDEPEND=""

PDEPEND="
	bentoo/bentoo-browser
	bentoo/bentoo-editors
	bentoo/bentoo-firmware
	gnome? ( bentoo/bentoo-gnome )
	mobile? ( bentoo/bentoo-mobile )
	bentoo/bentoo-system
  	"
