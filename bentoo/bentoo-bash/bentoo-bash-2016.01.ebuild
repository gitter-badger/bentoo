# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
DESCRIPTION="Bentoo bash meta ebuild"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
KEYWORDS="amd64 arm x86"
SLOT="0"
LICENSE="GPL-3"
IUSE=""

S="${WORKDIR}"

DEPEND=""
RDEPEND="${DEPEND}
	app-shells/bash
	"

src_install() {
	insinto /root
	newins "${FILESDIR}"/bashrc .bashrc
	insinto /root/.bashrc.d
	newins "${FILESDIR}"/00aliases 00aliases
	newins "${FILESDIR}"/01locale 01locale
	newins "${FILESDIR}"/02prompt 02prompt
	newins "${FILESDIR}"/03bash_completion 03bash_completion
	newins "${FILESDIR}"/04functions 04functions
	newins "${FILESDIR}"/05exports 05exports
	newins "${FILESDIR}"/06midnight-commander 06midnight-commander
	newins "${FILESDIR}"/07urxvt 07urxvt
	newins "${FILESDIR}"/99other 99other
}
