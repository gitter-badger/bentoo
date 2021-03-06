# Copyright 1999-2017 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"

inherit multilib

DESCRIPTION="Bentoo system release virtual package"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

IUSE=""
DEPEND=""
# Listing default packages for the current release
RDEPEND="virtual/service-manager"

src_unpack () {
	echo "Bentoo Linux ${ARCH} ${PV}" > "${T}/bentoo-release"

	# Anaconda expects a "release" somewhere in the string
	# and no trailing \n
	echo -n "Bentoo ${ARCH} release ${PV}" > "${T}/system-release"
	mkdir -p "${S}" || die
}

src_install () {
	insinto /etc
	doins "${T}"/bentoo-release
	doins "${T}"/system-release

	# Bug 3459 - reduce the risk of fork bombs
	insinto /etc/security/limits.d
	doins "${FILESDIR}/00-bentoo-anti-fork-bomb.conf"
}

pkg_postinst() {
	# Improve systemd support
	if [[ ! -L /etc/mtab ]] && [[ -e /proc/self/mounts ]]; then
		rm -f /etc/mtab
		einfo "Migrating /etc/mtab to a /proc/self/mounts symlink"
		ln -sf /proc/self/mounts /etc/mtab
	fi

	# force kdm back to the default runlevel if added to boot
	# this is in preparation for the logind migration
	local xdm_conf="${ROOT}/etc/conf.d/xdm"
	local xdm_boot_runlevel="${ROOT}/etc/runlevels/boot/xdm"
	local xdm_default_runlevel="${ROOT}/etc/runlevels/default/xdm"
	if [ -e "${xdm_conf}" ] && [ -e "${xdm_boot_runlevel}" ]; then
		DISPLAYMANAGER=""
		. "${xdm_conf}"
		if [ "${DISPLAYMANAGER}" = "kdm" ]; then
			elog "Moving xdm (kdm) from boot runlevel to default"
			elog "or logind will not work as expected"
			mv -f "${xdm_boot_runlevel}" "${xdm_default_runlevel}"
		fi
	fi

	# remove old hal udev rules.d file, if found. sys-apps/hal is long gone.
	rm -f "${ROOT}/lib/udev/rules.d/90-hal.rules"

	# make sure that systemd is correctly linked to /sbin/init
	# Drop this in 2015, keep in sync with systemd-sysv-utils
	ln -sf ../usr/lib/systemd/systemd "${ROOT}/sbin/init" || true
}
