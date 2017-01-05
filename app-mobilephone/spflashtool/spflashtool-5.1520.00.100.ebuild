# Copyright 1999-2017 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"

inherit linux-info

DESCRIPTION="SmartPhone Flash Tool for MTK based Android devices"
HOMEPAGE="http://spflashtool.com/"
SRC_URI="
	x86? ( http://spflashtool.com/download/SP_Flash_Tool_Linux_32Bit_v${PV}.zip )
	amd64? ( http://spflashtool.com/download/SP_Flash_Tool_exe_Linux_64Bit_v${PV}.zip )"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE="+udev-rules +system-qt"

DEPEND=""
RDEPEND="${DEPEND}
	system-qt? (
		dev-qt/qtgui:4
		dev-qt/qtwebkit:4
		dev-qt/qthelp:4
	)
	!system-qt? (
		media-libs/libpng:1.2
	)
	sys-apps/util-linux
	app-arch/bzip2"

S="${WORKDIR}/SP_Flash_Tool_exe_Linux_v5.1520.00.100"

pkg_pretend(){
	ewarn "Checking for CONFIG_USB_ACM..."
	linux-info_pkg_setup
	if ! linux_config_exists || ! linux_chkconfig_present USB_ACM; then
		ewarn "Usb modem (CDC ACM) support is required"
	fi
}

src_prepare() {
	if use system-qt; then
		# Remove packaged version of Qt libs
		rm "${S}/lib" -rf
	fi
}

src_install() {
	if use udev-rules; then
		insinto /lib/udev/rules.d/
		doins "${FILESDIR}/51-android.rules"
	fi
	local dest=/opt/${PN}
	dodir ${dest}
	insinto ${dest}
	insopts -m 0644
	doins -r *
	fperms 755 ${dest}/flash_tool ${dest}/libflashtool.so ${dest}/bin/assistant plugins/*/*.so
	newbin ${FILESDIR}/launcher.sh spflashtool
}

pkg_postinst(){
	ewarn "After first installation of udev rules run as root:"
	ewarn "# udevadm control --reload-rules"
}
