# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
DESCRIPTION="Bentoo editors meta ebuild"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
KEYWORDS="amd64 arm x86"
SLOT="0"
LICENSE="GPL-3"
IUSE="emacs +vim"

DEPEND=""
RDEPEND="${DEPEND}
	emacs? ( app-editors/emacs )
	vim? ( bentoo/bentoo-vim )
	"
