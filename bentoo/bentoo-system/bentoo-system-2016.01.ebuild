# Copyright 1999-2017 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
inherit mount-boot
DESCRIPTION="Bentoo system meta ebuild"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
KEYWORDS="amd64 arm x86"
SLOT="0"
LICENSE="GPL-3"

IUSE_VIDEO_CARDS="video_cards_nvidia video_cards_virtualbox video_cards_vmware"
IUSE="livecd livecd-stage1 lvm -optimus pax_kernel +rxvt +udf qemu zfs ${IUSE_VIDEO_CARDS}"

S="${WORKDIR}"

# Things needed for a running system and not for livecd
PDEPEND="livecd? ( bentoo/bentoo-livecd )
	!livecd? ( !bentoo/bentoo-livecd
	!app-misc/livecd-tools )"

# Basic systems
PDEPEND="${PDEPEND}
	qemu? ( app-emulation/virt-manager
		!livecd-stage1? ( sys-apps/usermode-utilities ) )
"

#    bentoo/bentoo-mpv
RDEPEND="${DEPEND}
	app-admin/checksec
	app-admin/logrotate
	app-admin/sudo
	app-admin/sysstat
	app-arch/p7zip
	app-arch/rpm2targz
	app-arch/sharutils
	app-arch/unrar
	app-arch/unzip
	app-arch/xz-utils
	app-crypt/gnupg
	app-misc/mc
	app-misc/tmux
	!arm? ( app-portage/cpuid2cpuflags )
	app-portage/eix
	app-portage/euses
	app-portage/gentoolkit
	app-portage/ibashrc
	app-portage/portage-utils
	app-text/tree
	bentoo/bentoo-bash
	bentoo/bentoo-irssi
	bentoo/bentoo-syslog-ng
	bentoo/bentoo-version
	dev-util/dialog
	dev-vcs/git
	dev-vcs/git-flow
	media-fonts/iso_latin_1
	media-gfx/graphviz
	media-video/mpv
	net-firewall/ipset
	net-misc/ntp
	net-p2p/transmission
	sys-apps/gptfdisk
	sys-apps/hdparm
	sys-apps/lm_sensors
	sys-apps/mlocate
	sys-apps/pciutils
	sys-apps/pcmciautils
	sys-apps/pv
	sys-apps/smartmontools
	sys-apps/usbutils
	sys-devel/ipatch
	sys-fs/cryptsetup
	lvm? ( sys-fs/lvm2 )
	sys-fs/squashfs-tools
	udf? ( sys-fs/udftools )
	livecd? ( sys-kernel/linux-firmware )
	!arm? ( !livecd-stage1? ( sys-kernel/genkernel-next || ( sys-boot/grub:0 sys-boot/grub-static sys-boot/grub:2 ) ) )
	!arm? ( sys-kernel/bentoo-sources )
	zfs? ( !livecd-stage1? ( amd64? ( !pax_kernel? ( sys-fs/zfs ) ) ) )
	!livecd-stage1? ( video_cards_virtualbox? ( app-emulation/virtualbox-guest-additions ) )
	sys-libs/gpm
	!arm? ( sys-power/acpid )
	!arm? ( sys-power/thermald )
	sys-power/hibernate-script
	sys-power/powertop
	sys-process/htop
	sys-process/iotop
	sys-process/lsof
	sys-process/time
	|| ( sys-process/vixie-cron virtual/cron )
	optimus? ( video_cards_nvidia? ( x11-misc/bumblebee ) )
	rxvt? ( bentoo/bentoo-rxvt )
	"

src_install() {
#	insinto /boot/grub
#	doins "${FILESDIR}"/bentoo.xpm.gz

	if use pax_kernel; then
		dosbin "${FILESDIR}"/toggle_hardened
		exeinto /root/Desktop/
		doexe "${FILESDIR}"/toggle_hardened.desktop
	fi

	# here is where we merge in things from root_overlay which make sense
	exeinto /root
	newexe "${FILESDIR}"/b43-commercial-${PV} b43-commercial

	#/etc
	insinto /etc
	newins "${FILESDIR}"/motd-${PV} motd

	#/etc/portage/postsync.d
	exeinto /etc/portage/postsync.d
	doexe "${FILESDIR}"/layman-sync

	if [ ! -e "${EROOT}/etc/env.d/02locale" ]
	then
		doenvd "${FILESDIR}"/02locale
	fi

	insinto /etc/fonts
	doins "${FILESDIR}"/local.conf

	exeinto /etc/local.d
	doexe "${FILESDIR}"/00-linux_link.start
	newexe "${FILESDIR}"/00-speed_shutdown.stop 00-speed_shutdown.stop
	newexe "${FILESDIR}"/99-power_saving.start 99-power_saving.start
}
