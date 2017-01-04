# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
inherit git-r3 systemd

KEYWORDS="~amd64 ~x86 ~arm-linux ~x86-linux"
DESCRIPTION="Android platform tools (adb and fastboot)"
HOMEPAGE="https://developer.android.com/tools/index.html"
SRC_URI=""

# Now use branch "5.1.1_r18"
MY_VER="5.1.1_r18"
MY_B="android-${MY_VER}"

# The entire source code is Apache-2.0, except for fastboot which is BSD.
LICENSE="Apache-2.0 BSD"
SLOT="0"
IUSE=""

RDEPEND="virtual/udev"

DEPEND="${RDEPEND}"

S="${WORKDIR}/system/core"

src_unpack() {
	EGIT_CLONE_TYPE="mirror"

	EGIT_REPO_URI="https://android.googlesource.com/platform/system/core"
	EGIT_CHECKOUT_DIR="${WORKDIR}/system/core"
	EGIT_BRANCH="${MY_B}"
	EGIT_COMMIT="$EGIT_BRANCH"
	git-r3_src_unpack
	unset EGIT_REPO_URI EGIT_CHECKOUT_DIR EGIT_BRANCH EGIT_COMMIT

	EGIT_REPO_URI="https://android.googlesource.com/platform/system/extras"
	EGIT_CHECKOUT_DIR="${WORKDIR}/system/extras"
	EGIT_BRANCH="${MY_B}"
	EGIT_COMMIT="$EGIT_BRANCH"
	git-r3_src_unpack
	unset EGIT_REPO_URI EGIT_CHECKOUT_DIR EGIT_BRANCH EGIT_COMMIT

	EGIT_REPO_URI="https://android.googlesource.com/platform/external/libselinux"
	EGIT_CHECKOUT_DIR="${WORKDIR}/external/libselinux"
	EGIT_BRANCH="${MY_B}"
	EGIT_COMMIT="$EGIT_BRANCH"
	git-r3_src_unpack
	unset EGIT_REPO_URI EGIT_CHECKOUT_DIR EGIT_BRANCH EGIT_COMMIT

	EGIT_REPO_URI="https://android.googlesource.com/platform/external/zlib"
	EGIT_CHECKOUT_DIR="${WORKDIR}/external/zlib"
	EGIT_BRANCH="${MY_B}"
	EGIT_COMMIT="$EGIT_BRANCH"
	git-r3_src_unpack
	unset EGIT_REPO_URI EGIT_CHECKOUT_DIR EGIT_BRANCH EGIT_COMMIT

	EGIT_REPO_URI="https://android.googlesource.com/platform/external/openssl"
	EGIT_CHECKOUT_DIR="${WORKDIR}/external/openssl"
	EGIT_BRANCH="${MY_B}"
	EGIT_COMMIT="$EGIT_BRANCH"
	git-r3_src_unpack
	unset EGIT_REPO_URI EGIT_CHECKOUT_DIR EGIT_BRANCH EGIT_COMMIT

	EGIT_REPO_URI="https://android.googlesource.com/platform/external/f2fs-tools"
	EGIT_CHECKOUT_DIR="${WORKDIR}/f2fs-tools"
	EGIT_BRANCH="${MY_B}"
	EGIT_COMMIT="$EGIT_BRANCH"
	git-r3_src_unpack
	unset EGIT_REPO_URI EGIT_CHECKOUT_DIR EGIT_BRANCH EGIT_COMMIT
}

src_prepare() {
	cp "${FILESDIR}"/core-${MY_VER}-Makefile "${WORKDIR}"/Makefile && cd "${WORKDIR}"; make || die
}

src_install() {
	exeinto /usr/bin
	doexe "${WORKDIR}"/adb
	doexe "${WORKDIR}"/fastboot
	doexe "${WORKDIR}"/mkbootimg
	dodoc "${WORKDIR}"/system/core/adb/{OVERVIEW,SERVICES}.TXT
	# udev rules
#	insinto /lib/udev/rules.d/
#	doins "${FILESDIR}"/51-android.rules
	# systemd unit file
	systemd_dounit "${FILESDIR}"/adb.service
}

pkg_postinst() {
	elog "Android Debug Bridge (adb) is a command-line tool used to communicate with and control"
	elog "Android device over a USB link from a computer. Fastboot is a command line tool used"
	elog "to directly flash the filesystem in Android devices from a host via USB."
	elog
}
