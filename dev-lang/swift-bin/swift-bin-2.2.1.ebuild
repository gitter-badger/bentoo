# Copyright 1999-2017 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
PYTHON_COMPAT=( python2_7 )

inherit python-r1

DESCRIPTION="The Swift programming language and debugger"
HOMEPAGE="https://swift.org"
#MY_P="swift-${PV}-RELEASE-ubuntu14.04"
MY_P="swift-${PV}-RELEASE-ubuntu15.10"
#SRC_URI="https://swift.org/builds/swift-${PV}-release/ubuntu1404/swift-${PV}-RELEASE/${MY_P}.tar.gz"
SRC_URI="https://swift.org/builds/swift-${PV}-release/ubuntu1510/swift-${PV}-RELEASE/${MY_P}.tar.gz"
RESTRICT="strip"

LICENSE="Apache-2.0"
SLOT=0
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/icu
		dev-libs/libbsd
		dev-libs/libedit
		dev-libs/libxml2
		dev-python/six[${PYTHON_USEDEP}]
		sys-apps/util-linux
		sys-devel/clang
		>=sys-libs/ncurses-5.9:5[tinfo]"

DEPEND="${RDEPEND}
		${PYTHON_DEPS}"

DOCS=( LICENSE.txt  )

S="${WORKDIR}/${MY_P}"

src_install() {
    # Permission fix
    find "${S}" -type d -exec chmod 755 {} +

    # Remove all unnecessary stuff
    rm -rf "${S}/usr/local"

    # Yuck! patching libedit SONAME
    find "${S}/usr/bin" -type f -exec sed -i 's/libedit\.so\.2/libedit\.so\.0/g' {} \;
    find "${S}/usr/lib" -type f -exec sed -i 's/libedit\.so\.2/libedit\.so\.0/g' {} \;

    # remove the six.py dumped in python's site packages
    rm "${S}/usr/lib/python2.7/site-packages/six.py"

    # Ensure the items have the right permissions..
    # some tarballs from upstream seem to have the wrong ones
    find "${S}/usr/bin" -type f -exec chmod a+rx {} \;
    find "${S}/usr/lib" -type f -exec chmod a+r {} \;

    # Update glibc map paths
    sed -i 's/\/x86_64-linux-gnu//g' "${S}/usr/lib/swift/glibc/module.map"

	# this is a precompiled tarball
	mkdir -p "${D}/opt/${MY_P}"
	cp -ar "${S}"/* "${D}/opt/${MY_P}" || die "Failed to copy stuff"
	mkdir -p "${D}/etc/env.d/swift"
	echo "export PATH=/opt/swift-${PV}/bin:\$PATH" > "${D}/etc/env.d/swift/99-swift-bin" || die "Failed to add env settings"
}
