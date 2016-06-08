# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: transmission-2.xx.eclass
# @MAINTAINER:
# slawomir.nizio@sabayon.org
# @AUTHOR:
# Sławomir Nizio <slawomir.nizio@sabayon.org>
# @BLURB: eclass to ease managing of Sabayon split net-p2p/transmission
# @DESCRIPTION:
# This eclass is to ease managing of split net-p2p/transmission for Sabayon.
# Its name contains a version that corresponds to net-p2p/transmission one,
# because the eclass will change often when needed to follow changes
# in Gentoo ebuild.
# Always call phase functions using their public names, such like:
# transmission-2.83_src_configure, and never _transmission_src_configure.

# @ECLASS-VARIABLE: TRANSMISSION_ECLASS_VERSION_OK
# @DESCRIPTION:
# Set this to x.y if you want to use transmission-x.y.eclass from ebuild
# with ${PV} different than x.y. This is to catch bugs.
: ${TRANSMISSION_ECLASS_VERSION_OK:=${PV}}

# @ECLASS-VARIABLE: E_TRANSM_TAIL
# @INTERNAL
# @DESCRIPTION:
# "Tail" of package name. Can take value gtk, qt4, etc. or can be empty.
E_TRANSM_TAIL=${PN#transmission}
E_TRANSM_TAIL=${E_TRANSM_TAIL#-}

# @FUNCTION: _transmission_is
# @INTERNAL
# @DESCRIPTION:
# Function used to check which variant of Transmission are we working on.
# Argument should be one of these: (none), gtk, qt4, qt5, daemon, cli, base.
# If argument is empty or omitted, true value means that it is
# net-p2p/transmission (metapackage).
_transmission_is() {
	local what=$1
	[[ ${what} = "${E_TRANSM_TAIL}" ]]
}

# @FUNCTION: _transmission_eclass_setup_functions
# @INTERNAL
# @DESCRIPTION:
# Function to setup functions. The eval uses strictly controlled variables,
# so it's OK.
_transmission_eclass_setup_functions() {
	local v=2.92
	local func
	for func in src_prepare src_configure src_compile \
			pkg_preinst pkg_postinst pkg_postrm; do
		eval "transmission-${v}_${func}() { _transmission_${func}; }"
	done
}

_transmission_eclass_setup_functions

MY_ECLASSES=""
_transmission_is gtk && MY_ECLASSES+="fdo-mime gnome2-utils"
_transmission_is qt4 && MY_ECLASSES+="fdo-mime qmake-utils"
_transmission_is qt5 && MY_ECLASSES+="fdo-mime qmake-utils"
_transmission_is "" || MY_ECLASSES+=" autotools flag-o-matic"
_transmission_is base && MY_ECLASSES+=" user"

inherit multilib ${MY_ECLASSES}

unset MY_ECLASSES

case ${EAPI:-0} in
	6) EXPORT_FUNCTIONS src_prepare src_configure src_compile \
		pkg_preinst pkg_postinst pkg_postrm ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

[[ ${PN} = transmission* ]] || \
	die "This eclass can only be used with net-p2p/transmission* ebuilds!"
# Bug catcher!
if ! [[ ${PV} = *9999* ]] && [[ ${TRANSMISSION_ECLASS_VERSION_OK} != ${ECLASS#*-} ]]; then
	eerror "used eclass ${ECLASS}"
	eerror "TRANSMISSION_ECLASS_VERSION_OK=${TRANSMISSION_ECLASS_VERSION_OK}"
	die "ebuild version ${PV} doesn't match with the eclass"
fi

MY_PN="transmission"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A Fast, Easy and Free BitTorrent client"
HOMEPAGE="http://www.transmissionbt.com/"
SRC_URI="http://download.transmissionbt.com/${MY_PN}/files/${MY_P}.tar.xz"

# web/LICENSE is always GPL-2 whereas COPYING allows either GPL-2 or GPL-3 for the rest
# transmission in licenses/ is for mentioning OpenSSL linking exception
# MIT is in several libtransmission/ headers
LICENSE="|| ( GPL-2 GPL-3 Transmission-OpenSSL-exception ) GPL-2 MIT"
SLOT="0"
IUSE=""
_transmission_is "" || IUSE+="libressl"

# only common dependencies plus blockers
RDEPEND=""
_transmission_is base || RDEPEND+="~net-p2p/transmission-base-${PV}"
if ! _transmission_is ""; then
	RDEPEND+="
	>=dev-libs/libevent-2.0.10:=
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl )
	net-libs/libnatpmp:=
	>=net-libs/miniupnpc-1.7:=
	>=net-misc/curl-7.16.3:=[ssl]
	sys-libs/zlib:="
fi

DEPEND="${RDEPEND}"
if _transmission_is base; then
	RDEPEND+=" !<net-p2p/transmission-gtk-${PV}
	!<net-p2p/transmission-qt4-${PV}
	!<net-p2p/transmission-qt5-${PV}
	!<net-p2p/transmission-daemon-${PV}
	!<net-p2p/transmission-cli-${PV}"
fi
if ! _transmission_is ""; then
	DEPEND+=" >=dev-libs/glib-2.32
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext
	virtual/os-headers"
fi

S="${WORKDIR}/${MY_P}"
_transmission_is "" && S="${WORKDIR}"

_transmission_src_prepare() {
	# Can't check it on top as the array could be set after inheriting the
	# eclass.
	if [[ ${#TRANSMISSION_PATCHES[@]} -gt 0 ]]; then
		die "Please switch to PATCHES. KTHXBYE."
	fi

	if _transmission_is ""; then
		eapply_user # it's mandatory
		return
	fi

	sed -i -e '/CFLAGS/s:-ggdb3::' configure.ac || die

	if ! use_if_iuse ayatana; then
		# Trick to avoid automagic dependency
		sed -i -e '/^LIBAPPINDICATOR_MINIMUM/s:=.*:=9999:' configure.ac || die
	fi

	# Pass our configuration dir to systemd unit file
	sed -i '/ExecStart/ s|$| -g /var/lib/transmission/config|' daemon/transmission-daemon.service || die

	# http://trac.transmissionbt.com/ticket/4324
	sed -i -e 's|noinst\(_PROGRAMS = $(TESTS)\)|check\1|' libtransmission/Makefile.am || die

	default
	eautoreconf

	if ! _transmission_is base; then
		local sedcmd="s:\$(top_builddir)/libtransmission/libtransmission.a:"
		sedcmd+="${EROOT}usr/$(get_libdir)/libtransmission.a:"
		find . -name Makefile.in -exec sed -i -e "${sedcmd}" {} \; || die
		sed -i -e '/libtransmission \\/d' Makefile.in || die
		if _transmission_is qt4 || _transmission_is qt5; then
			sedcmd="s:\$\${TRANSMISSION_TOP}/libtransmission/libtransmission.a:"
			sedcmd+="${EROOT}usr/$(get_libdir)/libtransmission.a:"
			sed -i -e "${sedcmd}" qt/qtr.pro || die
		fi
	fi
}

_transmission_src_configure() {
	_transmission_is "" && return

	# https://bugs.gentoo.org/577528
	append-cppflags -D_LARGEFILE64_SOURCE=1

	local econfargs=(
		--enable-external-natpmp
	)

	if _transmission_is base; then
		export ac_cv_header_xfs_xfs_h=$(usex xfs)
		econfargs+=(
			--disable-cli
			--disable-daemon
			--without-gtk
			$(use_enable lightweight)
		)
	elif _transmission_is cli; then
		econfargs+=(
			--enable-cli
			--disable-daemon
			--without-gtk
		)
	elif _transmission_is daemon; then
		econfargs+=(
			--disable-cli
			--enable-daemon
			--without-gtk
			$(use_with systemd systemd-daemon)
		)
	elif _transmission_is gtk; then
		econfargs+=(
			--disable-cli
			--disable-daemon
			--with-gtk
		)
	elif _transmission_is qt4 || _transmission_is qt5; then
		econfargs+=(
			--disable-cli
			--disable-daemon
			--without-gtk
		)
	else
		die "Something is wrong... (E_TRANSM_TAIL=$E_TRANSM_TAIL)"
	fi

	econf "${econfargs[@]}"
	if _transmission_is qt4 || _transmission_is qt5; then
		pushd qt >/dev/null || die
		_transmission_is qt4 && eqmake4 qtr.pro
		_transmission_is qt5 && eqmake5 qtr.pro
		popd >/dev/null || die
	fi
}

_transmission_src_compile() {
	_transmission_is "" && return

	emake

	if _transmission_is qt4 || _transmission_is qt5; then
		local qt_bindir
		_transmission_is qt4 && qt_bindir=$(qt4_get_bindir)
		_transmission_is qt5 && qt_bindir=$(qt5_get_bindir)
		emake -C qt
		"${qt_bindir}"/lrelease qt/translations/*.ts || die
	fi
}


# Note: not providing src_install. Too many differences and too much code
# which would only clutter this pretty eclass.

_transmission_pkg_preinst() {
	_transmission_is gtk && gnome2_icon_savelist
}

_transmission_pkg_postinst() {
	if _transmission_is gtk || _transmission_is qt4 || _transmission_is qt5; then
		fdo-mime_desktop_database_update
	fi

	_transmission_is gtk && gnome2_icon_cache_update

	if _transmission_is base; then
		enewgroup transmission
		enewuser transmission -1 -1 -1 transmission
	fi

	if _transmission_is daemon; then
		elog "If you use transmission-daemon, please, set 'rpc-username' and"
		elog "'rpc-password' (in plain text, transmission-daemon will hash it on"
		elog "start) in settings.json file located at /var/lib/transmission/config or"
		elog "any other appropriate config directory."
	fi

	if _transmission_is gtk; then
		# in -gtk only?
		elog
		elog "To enable sound emerge media-libs/libcanberra and check that at least"
		elog "some sound them is selected. For this go:"
		elog "Gnome/system/preferences/sound themes tab and 'sound theme: default'"
		elog
	fi

	if _transmission_is base; then
		elog "Since µTP is enabled by default, transmission needs large kernel buffers for"
		elog "the UDP socket. You can append following lines into /etc/sysctl.conf:"
		elog " net.core.rmem_max = 4194304"
		elog " net.core.wmem_max = 1048576"
		elog "and run sysctl -p"
	fi
}

_transmission_pkg_postrm() {
	if _transmission_is gtk || _transmission_is qt4 || _transmission_is qt5; then
		fdo-mime_desktop_database_update
	fi

	_transmission_is gtk && gnome2_icon_cache_update
}
