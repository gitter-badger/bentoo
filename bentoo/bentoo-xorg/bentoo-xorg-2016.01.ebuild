# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
DESCRIPTION="Bentoo xorg meta ebuild"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
KEYWORDS="amd64 arm x86"
SLOT="0"
LICENSE="GPL-3"

IUSE_INPUT_DEVICES="keyboard mouse synaptics"
IUSE_VIDEO_CARDS="nouveau nvidia"
IUSE="${IUSE_INPUT_DEVICES} ${IUSE_VIDEO_CARDS}"

S="${WORKDIR}"

DEPEND=""
RDEPEND="${DEPEND}
	x11-base/xorg-x11
	"

src_install() {
	insinto /etc/X11/xorg.conf.d
	newins "${FILESDIR}"/20-files.conf 20-files.conf
	newins "${FILESDIR}"/10-monitor.conf 10-monitor.conf

	if use keyboard; then
		newins "${FILESDIR}"/10-evdev.conf 10-evdev.conf
	fi

	if use mouse; then
		newins "${FILESDIR}"/11-mouse.conf 11-mouse.conf
	fi

	if use nvidia; then
		newins "${FILESDIR}"/20-nvidia.conf 20-nvidia.conf
	fi

#	if use nouveau; then
#		newins "${FILESDIR}"/20-nouveau.conf 20-nouveau.conf
#	fi

	if use synaptics; then
		newins "${FILESDIR}"/50-synaptics.conf 50-synaptics.conf
	fi
}
