# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

EAPI=6

PYTHON_COMPAT=( python{2_7,3_5} )

inherit python-single-r1

DESCRIPTION="EFL user interface for connman"
HOMEPAGE="http://www.enlightenment.org/"
SRC_URI="http://download.enlightenment.org/rel/apps/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/python-efl[${PYTHON_USEDEP}]
	net-misc/connman:0"

DEPEND="${RDEPEND}"
