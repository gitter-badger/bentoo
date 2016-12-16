# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
DESCRIPTION="Bentoo firmware meta ebuild"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
KEYWORDS="amd64 arm x86"
SLOT="0"
LICENSE="GPL-3"
IUSE="b43 intel nouveau vdpau"

DEPEND=""
RDEPEND="${DEPEND}
	b43? ( sys-firmware/b43-firmware )
	intel? ( sys-apps/iucode_tool sys-firmware/intel-microcode )
	nouveau? ( vdpau? ( sys-firmware/nouveau-firmware ) )
	"
