# Copyright 1999-2015 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

EAPI=5
SLOT="0"
KEYWORDS="x86 amd64 ppc ppc64"
DEPEND="<dev-lang/python-3"
RDEPEND=""
RESTRICT="bindist mirror strip"
IUSE="-bindist"
REQUIRED_USE="!bindist"

S="${WORKDIR}"

src_unpack() {
	use x86 && NV_ARCH="x86"
	use amd64 && NV_ARCH="x86_64"
	mkdir "${S}/NVIDIA-Linux-${NV_ARCH}-${PV}"
	cd "${S}/NVIDIA-Linux-${NV_ARCH}-${PV}"
	unpack_makeself "NVIDIA-Linux-${NV_ARCH}-${PV}.run"
}

src_compile() {
	python2 "${DISTDIR}"/nvidia_extract_firmware.py
}

src_install() {
	insinto /lib/firmware/nouveau
	doins nv* vuc-* || die "doins failed"
}
