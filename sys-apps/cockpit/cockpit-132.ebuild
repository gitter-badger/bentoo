# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"

inherit user pam autotools eutils

DESCRIPTION="A user interface for Linux servers"
HOMEPAGE="http://cockpit-project.org/"

if [[ ${PV} == 9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/cockpit-project/cockpit.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/cockpit-project/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="+debug test +pcp doc"

REQUIRED_USE="debug"

DEPEND="
	>=net-libs/libssh-0.6[server]
	>=dev-libs/json-glib-1.0.0
	>=sys-auth/polkit-0.105
	sys-fs/lvm2
	app-crypt/mit-krb5
	dev-util/gdbus-codegen
	pcp? ( sys-apps/pcp )
	net-libs/nodejs[npm]
	app-admin/sudo
	doc? ( app-text/xmlto )"

RDEPEND="${DEPEND}
	>=virtual/libgudev-230
	net-libs/glib-networking[ssl]"

pkg_setup(){
	if [ -z "$(egetent group cockpit-ws 2>/dev/null)" ]; then
		enewgroup cockpit-ws
		einfo
		einfo "The group 'cockpit-ws' has been created. Any users you add to this"
		einfo "group have access to files created by the daemons."
		einfo
	fi
	if [ -z "$(egetent passwd cockpit-ws 2>/dev/null)" ]; then
		enewuser cockpit-ws -1 -1 /var/lib/cockpit cockpit-ws
		einfo
		einfo "The user 'cockpit-ws' has been created."
		einfo
	fi
}

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure() {
	local myconf=(
		$(use_enable debug)
		$(use_enable pcp)
		$(use_enable doc)
		"--with-pamdir=/lib64/security"
		"--with-cockpit-user=cockpit-ws"
		"--with-cockpit-group=cockpit-ws"
		"--localstatedir=${ROOT}/var"
		"--with-branding=auto")
	econf "${myconf[@]}"
}

src_install(){
	emake DESTDIR="${D}"  install || die "emake install failed"
	ewarn "Installing experimetal pam configuration file"
	ewarn "use at your own risk"
	newpamd "${FILESDIR}/cockpit.pam" cockpit
	dodoc README.md AUTHORS
}
