# Copyright 1999-2017 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
inherit git-r3 systemd udev

KEYWORDS="~amd64 ~x86 ~arm-linux ~x86-linux"
DESCRIPTION="Android platform tools (adb and fastboot)"
HOMEPAGE="https://sites.google.com/a/android.com/tools/"
SRC_URI=""

# Now use branch "android-7.1.1_r13"
MY_VER="${PV/p/r}"
MY_B="android-${MY_VER}"

# The entire source code is Apache-2.0, except for fastboot which is BSD.
LICENSE="Apache-2.0 BSD"
SLOT="0"
IUSE=""

RDEPEND="virtual/udev"

DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_unpack() {
	EGIT_CLONE_TYPE="mirror"

	local r
	for r in system/core system/extras external/libselinux external/f2fs-tools external/gtest external/safe-iop; do
		EGIT_REPO_URI="https://android.googlesource.com/platform/${r}"
		EGIT_CHECKOUT_DIR="${WORKDIR}/${r}"
		EGIT_BRANCH="${MY_B}"
		EGIT_COMMIT="$EGIT_BRANCH"
		git-r3_src_unpack
		unset EGIT_REPO_URI EGIT_CHECKOUT_DIR EGIT_BRANCH EGIT_COMMIT
	done
}

src_prepare() {
	ipatch push . "${FILESDIR}"/${P}-musl-fixes.patch
	ipatch push . "${FILESDIR}"/${P}-Makefile.patch

	eapply_user
}

src_install() {
	exeinto /usr/bin
	doexe "${WORKDIR}"/system/core/adb/adb
	doexe "${WORKDIR}"/system/core/fastboot/fastboot
	dodoc "${WORKDIR}"/system/core/adb/NOTICE "${WORKDIR}"/system/core/adb/{OVERVIEW,SERVICES,SYNC}.TXT
	# udev rules
	udev_dorules "${FILESDIR}"/51-android.rules
	# systemd unit file
	systemd_dounit "${FILESDIR}"/adb.service
}

pkg_postinst() {
	elog "Android Debug Bridge (adb) is a command-line tool used to communicate with and control"
	elog "Android device over a USB link from a computer. Fastboot is a command line tool used"
	elog "to directly flash the filesystem in Android devices from a host via USB."
	elog
}
