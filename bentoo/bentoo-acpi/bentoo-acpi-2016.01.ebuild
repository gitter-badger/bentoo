# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
DESCRIPTION="Bentoo acpi meta ebuild"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
KEYWORDS="amd64 arm x86"
SLOT="0"
LICENSE="GPL-3"
IUSE="binwalk +iasl"

DEPEND=""

RDEPEND=""

PDEPEND="
	binwalk? ( app-misc/binwalk )
	+iasl? ( sys-power/iasl )
"
