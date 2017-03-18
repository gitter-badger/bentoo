# Copyright 1999-2017 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
DESCRIPTION="Bentoo proxy meta ebuild"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
LICENSE="GPL"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="privoxy tor"

DEPEND=""

RDEPEND="${DEPEND}
	privoxy? ( net-proxy/privoxy )
	tor? ( net-vpn/tor )
	"
