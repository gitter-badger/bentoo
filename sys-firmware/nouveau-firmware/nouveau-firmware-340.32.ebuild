# Copyright 1999-2017 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"

inherit unpacker

DESCRIPTION="Kernel and mesa firmware for nouveau (video accel and pgraph)."
HOMEPAGE="http://nouveau.freedesktop.org/wiki/VideoAcceleration/"
NV_URI="http://us.download.nvidia.com/XFree86"
SRC_URI="https://raw.github.com/imirkin/re-vp2/master/extract_firmware.py -> nvidia_extract_firmware.py
	x86?	( ${NV_URI}/Linux-x86/${PV}/NVIDIA-Linux-x86-${PV}.run )
	amd64?	( ${NV_URI}/Linux-x86_64/${PV}/NVIDIA-Linux-x86_64-${PV}.run )"

LICENSE="MIT NVIDIA-r1"
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
