# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
inherit autotools eutils systemd

DESCRIPTION="rxvt clone with xft and unicode support"
HOMEPAGE="http://software.schmorp.de/pkg/rxvt-unicode.html"
SRC_URI="http://dist.schmorp.de/rxvt-unicode/Attic/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="
	256-color alt-font-width blink buffer-on-clear +focused-urgency
	fading-colors +font-styles iso14755 +mousewheel +perl pixbuf secondary-wheel
	startup-notification xft unicode3 +vanilla wcwidth
"

RDEPEND="
	>=sys-libs/ncurses-5.7-r6:=
	kernel_Darwin? ( dev-perl/Mac-Pasteboard )
	media-libs/fontconfig
	perl? ( dev-lang/perl:= )
	pixbuf? ( x11-libs/gdk-pixbuf x11-libs/gtk+:2 )
	startup-notification? ( x11-libs/startup-notification )
	x11-libs/libX11
	x11-libs/libXrender
	xft? ( x11-libs/libXft )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	x11-proto/xproto
"

RESTRICT="test"
REQUIRED_USE="vanilla? ( !alt-font-width !buffer-on-clear focused-urgency !secondary-wheel !wcwidth )"

src_prepare() {
	# fix for prefix not installing properly
#	ipatch push . "${FILESDIR}"/${PN}-9.06-case-insensitive-fs.patch
#	ipatch push . "${FILESDIR}"/${PN}-9.21-xsubpp.patch

	if ! use vanilla; then
		ewarn "You are going to include unsupported third-party bug fixes/features."
		ewarn "If you want even more control over patches, then set USE=vanilla"
		ewarn "and store your patch set in /etc/portage/patches/${CATEGORY}/${PF}/"

		use wcwidth && ipatch push . doc/wcwidth.patch

		# bug #240165
		use focused-urgency || ipatch push . "${FILESDIR}"/${PN}-9.06-no-urgency-if-focused.diff

		# bug #263638
		ipatch push . "${FILESDIR}"/${PN}-9.06-popups-hangs.patch

		# bug #237271
		ipatch push . "${FILESDIR}"/${PN}-9.05_no-MOTIF-WM-INFO.patch

		# support for wheel scrolling on secondary screens
		use secondary-wheel && ipatch push . "${FILESDIR}"/${PN}-9.19-secondary-wheel.patch

		# ctrl-l buffer fix
		use buffer-on-clear && ipatch push . "${FILESDIR}"/${PN}-9.14-clear.patch

		use alt-font-width && ipatch push . "${FILESDIR}"/${PN}-9.06-font-width.patch
	fi

	# kill the rxvt-unicode terminfo file - #192083
	sed -i -e "/rxvt-unicode.terminfo/d" doc/Makefile.in || die "sed failed"

	eapply_user

	eautoreconf
}

src_configure() {
	local myconf=''

	use iso14755 || myconf='--disable-iso14755'

	econf --enable-everything \
		$(use_enable 256-color) \
		$(use_enable blink text-blink) \
		$(use_enable fading-colors fading) \
		$(use_enable font-styles) \
		$(use_enable mousewheel) \
		$(use_enable perl) \
		$(use_enable pixbuf) \
		$(use_enable startup-notification) \
		$(use_enable xft) \
		$(use_enable unicode3) \
		${myconf}
}

src_compile() {
	emake || die "emake failed"

	sed -i \
		-e 's/RXVT_BASENAME = "rxvt"/RXVT_BASENAME = "urxvt"/' \
		"${S}"/doc/rxvt-tabbed || die "tabs sed failed"
}

src_install() {
	default

	dodoc \
		README.FAQ Changes doc/README* doc/changes.txt doc/etc/* doc/rxvt-tabbed

	domenu "${FILESDIR}/urxvt.desktop"
	domenu "${FILESDIR}/urxvt-tabbed.desktop"
	domenu "${FILESDIR}/urxvtc.desktop"

	systemd_dounit "${FILESDIR}"/urxvtd@.service
}

pkg_postinst() {
	if use buffer-on-clear; then
		ewarn "You have enabled the buffer-on-clear USE flag."
		ewarn "Please note that, although this works well for most prompts,"
		ewarn "there have been cases with fancy prompts, like bug #397829,"
		ewarn "where it caused issues. Proceed with caution."
		ewarn "  (keep this terminal open until you make sure it works)"
	fi
	if use secondary-wheel; then
		elog "You have enabled the secondary-wheel USE flag."
		elog "This allows you to scroll in secondary screens"
		elog "(like mutt's message list/view or nano) using the mouse wheel."
		elog
		elog "To actually enable the feature you have to add"
		elog "  URxvt*secondaryWheel: true"
		elog "in your ~/.Xdefaults file"
	fi
	elog "To use Daemon-Client setup"
	elog "Pass the username when starting the service:"
	elog
	elog "  systemctl enable urxvtd@username.service"
	elog
	elog "To start client run:"
	elog
	elog "  urxvtc"
}
