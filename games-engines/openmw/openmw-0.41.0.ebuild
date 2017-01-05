# Copyright 1999-2017 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
inherit gnome2-utils cmake-utils

DESCRIPTION="An open source reimplementation of TES III: Morrowind"
HOMEPAGE="http://openmw.org/"
SRC_URI="https://github.com/OpenMW/openmw/archive/${P%_*}.tar.gz"

LICENSE="GPL-3 MIT BitstreamVera ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc devtools +qt5"

# 0.37.0: >=media-video/ffmpeg-0.9 is required for swresample
RDEPEND="
	>=dev-games/openscenegraph-3.3.4[ffmpeg,jpeg,png,qt5,sdl,svg,truetype,zlib]
	media-libs/libtxc_dxtn
	>=dev-games/mygui-3.2.2
	>=dev-libs/boost-1.60.0[threads]
	dev-libs/tinyxml[stl]
	media-libs/libsdl2[joystick,opengl,X,video]
	media-libs/openal
	>=sci-physics/bullet-2.83
	>=media-video/ffmpeg-0.9
	virtual/opengl
	qt5? ( app-arch/unshield
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen
		dev-python/sphinx
		media-gfx/graphviz )"

S=${WORKDIR}/${PN}-${P}

src_prepare() {
	default

	# We don't install license files
	sed -e '/LICDIR/d' \
		-i CMakeLists.txt || die
	# Use the system tinyxml headers
	sed -e 's/"tinyxml.h"/<tinyxml.h>/g' \
		-e 's/"tinystr.h"/<tinystr.h>/g' \
		-i extern/oics/ICSPrerequisites.h || die
}

src_configure() {
	use devtools && ! use qt5 && elog "'qt5' USE flag is disabled, 'openmw-cs' will not be installed"

	local mycmakeargs=(
		-DBUILD_BSATOOL=$(usex devtools)
		-DBUILD_ESMTOOL=$(usex devtools)
		-DBUILD_OPENCS=$(usex devtools $(usex qt5))
		-DBUILD_NIFTEST=$(usex devtools)
		-DBUILD_LAUNCHER=$(usex qt5)
		-DBUILD_WIZARD=$(usex qt5)
		-DBUILD_UNITTESTS=OFF
		-DGLOBAL_DATA_PATH=/usr/share
		-DICONDIR="/usr/share/icons/hicolor/256x256/apps"
		-DMORROWIND_DATA_FILES="/usr/share/${PN}/data"
		-DOPENMW_RESOURCE_FILES="/usr/share/${PN}/resources"
		-DUSE_SYSTEM_TINYXML=ON
		-DDESIRED_QT_VERSION=5
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use doc ; then
		emake -C "${CMAKE_BUILD_DIR}" doc
		find "${CMAKE_BUILD_DIR}"/docs/Doxygen/html \
			-name '*.md5' -type f -delete || die
	fi
}

src_install() {
	cmake-utils_src_install

	# about 43k files, dodoc seems to have trouble
	if use doc ; then
		dodir "/usr/share/doc/${PF}"
		mv "${CMAKE_BUILD_DIR}"/docs/Doxygen/html \
			"${D}/usr/share/doc/${PF}/" || die
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update

	elog "You need the original Morrowind data files. If you haven't"
	elog "installed them yet, you can install them straight via the"
	elog "installation wizard which is the officially"
	elog "supported method (either by using the launcher or by calling"
	elog "'openmw-wizard' directly)."

	if ! use qt5; then
		elog
		elog "'qt5' USE flag is disabled, 'openmw-launcher' and"
		elog "'openmw-wizard' are not available. You are on your own for"
		elog "making the Morrowind data files available and pointing"
		elog "openmw at them."
		elog
		elog "Additionally; you must import the Morrowind.ini file before"
		elog "running openmw with the Morrowind data files for the first"
		elog "time. Typically this can be done like so:"
		elog
		elog "    mkdir -p ~/.config/openmw"
		elog "    openmw-iniimporter /path/to/Morrowind.ini ~/.config/openmw/openmw.cfg"
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
}
