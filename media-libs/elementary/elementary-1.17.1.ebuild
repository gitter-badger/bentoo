# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"

case "${PV}" in
	(*9999*)
	KEYWORDS=""
	inherit git-2
	EGIT_REPO_URI="git://git.enlightenment.org/core/${PN}.git"
	EGIT_PROJECT="${PN}.git"
	case "${PV}" in
		(*.9999*) EGIT_BRANCH="${PN}-${PV:0:4}";;
	esac
	AUTOTOOLS_AUTORECONF=1
	;;
	(*)
	KEYWORDS="~amd64 ~arm ~x86"
	SRC_URI="https://download.enlightenment.org/rel/libs/${PN}/${P/_/-}.tar.xz"
	;;
esac

RESTRICT="test"

DESCRIPTION="Basic widget set, based on EFL for mobile touch-screen devices"
HOMEPAGE="http://trac.enlightenment.org/e/wiki/Elementary"

LICENSE="LGPL-2.1"
SLOT="0/${PV:0:4}"
IUSE="X debug doc examples fbcon javascript +nls quicklaunch sdl static-libs test wayland"

RDEPEND="
	>=dev-libs/efl-${PV:0:4}[X?,fbcon?,png,sdl?,wayland?]
	javascript? ( net-libs/nodejs )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	doc? ( app-doc/doxygen )
	test? ( >=dev-libs/check-0.9.5 )"

S="${WORKDIR}/${P/_/-}"

multilib_src_configure() {
	local -a myeconfargs=(
		${EXTRA_ELEMENTARY_CONF}
		$(use_enable X ecore-x)
		$(use_enable fbcon ecore-fb)
		$(use_enable javascript js-bindings)
		$(use_enable sdl ecore-sdl)
		$(use_enable wayland ecore-wl2)
		--disable-ecore-cocoa
		--disable-ecore-psl1ght
		--disable-ecore-win32
		$(use_enable debug)
		$(use_enable doc)
		$(use_enable examples build-examples)
		$(use_enable examples install-examples)
		$(use_enable nls)
		$(use_enable static-libs static)
		$(use_enable quicklaunch quick-launch)
		--with-tests=$(usex test regular none)
		--with-elementary-web-backend=none
	)
	autotools-utils_src_configure
}
