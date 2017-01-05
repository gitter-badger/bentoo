# Copyright 1999-2017 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
KEYWORDS="amd64 arm x86"
DESCRIPTION="Bentoo syslog-ng meta ebuild"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
SLOT="0"
LICENSE="GPL-3"
IUSE=""

S="${WORKDIR}"

DEPEND=""
RDEPEND="${DEPEND}
	( app-admin/syslog-ng virtual/logger )
	"

src_install() {
	insinto /etc/syslog-ng
	newins "${FILESDIR}"/syslog-ng.conf-${PV} syslog-ng.conf || die "doins syslog-ng.conf failed"
}
