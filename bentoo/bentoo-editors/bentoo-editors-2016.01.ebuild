# Copyright 1999-2015 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

EAPI=5
DESCRIPTION="Bentoo editors meta ebuild"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
KEYWORDS="amd64 arm x86"
SLOT="0"
LICENSE="GPL-3"
IUSE="+vim"

DEPEND=""
RDEPEND="${DEPEND}
	app-editors/nano
	vim? ( app-editors/vim )
	"
