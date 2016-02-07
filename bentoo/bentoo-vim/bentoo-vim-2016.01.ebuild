# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

EAPI="6"
DESCRIPTION="Bentoo vim meta ebuild"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
KEYWORDS="amd64 arm x86"
SLOT="0"
LICENSE="GPL-3"
IUSE="gnome kde"

DEPEND=""
RDEPEND="${DEPEND}
	app-editors/vim
	app-vim/pathogen
	app-vim/syntastic
	gnome? ( app-editors/gvim )
	kde? ( app-editors/vim-qt )
	"

