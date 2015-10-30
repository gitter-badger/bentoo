# Copyright 1999-2015 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

EAPI=5

inherit eutils toolchain

GCC_RELEASE_VER=${PV}
GCC_VER="${PV/_p*/}"
DATE_VERSION="${PV/*_p}"
DATE_YEAR="${DATE_VERSION:0:4}"
DATE_YEAR_L="${DATE_VERSION:2:2}"
DATE_MONTH="${DATE_VERSION:4:6}"
LINARO_VER="${GCC_VER}-${DATE_YEAR}.${DATE_MONTH}"

DESCRIPTION="The GNU Compiler Collection with Linaro patches"
HOMEPAGE="http://www.linaro.org"
SRC_URI="http://releases.linaro.org/${DATE_YEAR_L}.${DATE_MONTH}/components/toolchain/gcc-linaro/${GCC_VER}/gcc-linaro-${LINARO_VER}.tar.bz2
gcj? ( ftp://sourceware.org/pub/java/ecj-4.5.jar )"
RESTRICT="mirror"
LICENSE="GPL-3+ LGPL-3+ || ( GPL-3+ libgcc libstdc++ gcc-runtime-library-exception-3.1 ) FDL-1.3+"

KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd"

IUSE="cxx altivec awt doc fixed-point fortran gcj go graphite hardened libssp multilib objc objc++ objc-gc openmp"

RDEPEND=""
DEPEND="${RDEPEND}
	elibc_glibc? ( >=sys-libs/glibc-2.8 )
	>=${CATEGORY}/binutils-2.18"

if [[ ${CATEGORY} != cross-* ]] ; then
	PDEPEND="${PDEPEND} elibc_glibc? ( >=sys-libs/glibc-2.8 )"
fi

src_unpack() {
	unpack ${A}
	export S="${WORKDIR}/gcc-linaro-${LINARO_VER}"
	export BRANDING_GCC_PKGVERSION="Linaro ${LINARO_VER}"
}

pkg_setup() {
	toolchain_pkg_setup
}
