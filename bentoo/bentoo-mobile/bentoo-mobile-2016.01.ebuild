# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

EAPI=5
KEYWORDS="amd64 arm x86"
DESCRIPTION="Bentoo mobile meta ebuild"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
SLOT="0"
LICENSE="GPL-3"
IUSE="+android"

DEPEND=""
RDEPEND="${DEPEND}
	android? ( =dev-util/android-tools-5.1.1_p18 )
	"
