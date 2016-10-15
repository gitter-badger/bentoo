# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
PYTHON_COMPAT=(python{2_7,3_3})
inherit user eutils python-any-r1

DESCRIPTION="Performance Co-Pilot, system performance and analysis framework"
HOMEPAGE="http://pcp.io"
SRC_URI="https://github.com/performancecopilot/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="+ssp +pie threads infiniband discovery systemd X qt4 python papi perfevent manager webapi doc"

DEPEND=" systemd? ( sys-apps/systemd )
	X? ( x11-libs/libXt )
	qt4? ( dev-qt/qtcore:4 )
	python? ( ${PYTHON_DEPS} )
	perfevent? ( dev-libs/libpfm )
	papi? ( dev-libs/papi )
	discovery? ( net-dns/avahi[dbus] )
	webapi? ( net-libs/libmicrohttpd[messages] )
	doc? ( app-text/xmlto )"

RDEPEND="${DEPEND}"

pkg_setup(){
	if [ -z "$(egetent group pcp 2>/dev/null)" ]; then
		enewgroup pcp
		einfo
		einfo "The group 'pcp' has been created. Any users you add to this"
		einfo "group have access to files created by the daemons."
		einfo
	fi

	if [ -z "$(egetent passwd pcp 2>/dev/null)" ]; then
		enewuser pcp -1    -1 /var/lib/pcp pcp
		einfo
		einfo "The user 'pcp' has been created."
		einfo
	fi
	use python && python-any-r1_pkg_setup
}

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure() {
	# Setting xmlto as default documentation generator
	use doc && export BOOK_TOOLCHAIN="xmlto"

	# Configuration flags
	local myconf="\
		--prefix=${ROOT}/usr \
		--sysconfdir=${ROOT}/etc \
		--localstatedir=${ROOT}/var \
		$(use_enable ssp) \
		$(use_enable pie) \
		$(use_with threads) \
		$(use_with infiniband) \
		$(use_with discovery) \
		$(use_with systemd) \
		$(use_with papi) \
		$(use_with perfevent) \
		$(use_with manager) \
		$(use_with webapi) "
	use python && myconf+=" --with-python"
	use doc    && myconf+=" --with-books"
	use qt4    && myconf+=" --with-qt" || myconf+=" --without-qt"
	use X      && myconf+=" --with-x"
	econf $myconf
}

src_compile(){
	emake
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc CHANGELOG README.md
}
