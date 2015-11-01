# Copyright 1999-2015 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

EAPI=5
inherit mount-boot
DESCRIPTION="Bentoo system meta ebuild"
HOMEPAGE="https://bitbucket.org/redeyeteam/bentoo"
KEYWORDS="amd64 arm x86"
SLOT="0"
LICENSE="GPL-3"

IUSE_VIDEO_CARDS="video_cards_nvidia video_cards_virtualbox video_cards_vmware"
IUSE="livecd livecd-stage1 lvm pax_kernel +rxvt qemu zfs ${IUSE_VIDEO_CARDS}"

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

RDEPEND="${DEPEND}
	app-admin/logrotate
	app-admin/sudo
	( app-admin/syslog-ng virtual/logger )
	app-admin/sysstat
	app-arch/sharutils
	app-arch/unrar
	app-arch/unzip
	app-arch/xz-utils
	app-crypt/gnupg
	app-misc/mc
	app-misc/screen
	!arm? ( app-portage/cpuinfo2cpuflags )
	app-portage/eix
	app-portage/euses
	app-portage/gentoolkit
	app-portage/ibashrc
	app-portage/layman
	app-portage/portage-utils
	app-text/tree
	dev-util/dialog
	dev-vcs/git
	dev-vcs/git-flow
	media-fonts/iso_latin_1
	media-gfx/graphviz
	media-video/mpv
	net-irc/irssi
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
	livecd? ( sys-kernel/linux-firmware )
	!arm? ( !livecd-stage1? ( sys-kernel/genkernel-next || ( sys-boot/grub:0 sys-boot/grub-static sys-boot/grub:2 ) ) )
	!arm? ( sys-kernel/bentoo-sources )
	zfs? ( !livecd-stage1? ( amd64? ( !pax_kernel? ( sys-fs/zfs ) ) ) )
	!livecd-stage1? ( video_cards_virtualbox? ( app-emulation/virtualbox-guest-additions ) )
	sys-libs/gpm
	!arm? ( sys-power/acpid )
	sys-power/hibernate-script
	sys-process/htop
	sys-process/iotop
	sys-process/lsof
	sys-process/time
	|| ( sys-process/vixie-cron virtual/cron )
	video_cards_nvidia? ( x11-misc/bumblebee )
	rxvt? ( x11-terms/rxvt-unicode )
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
	newexe "${FILESDIR}"/b43-commercial-2015.10 b43-commercial

	#/etc
	insinto /etc
	echo "Bentoo Release ${PV}" > bentoo-release
	doins bentoo-release
	newins "${FILESDIR}"/motd-2015.10 motd
	newins "${FILESDIR}"/issue.logo-2015.10 issue.logo

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

	exeinto /etc/syslog-ng
	newins "${FILESDIR}"/syslog-ng.conf-2015.10 syslog-ng.conf
}
