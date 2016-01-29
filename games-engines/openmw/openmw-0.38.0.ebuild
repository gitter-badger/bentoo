# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

EAPI="6"

inherit eutils gnome2-utils multilib cmake-utils

DESCRIPTION="Unofficial open source engine re-implementation of the game Morrowind"
HOMEPAGE="http://openmw.org/"
SRC_URI="https://github.com/OpenMW/openmw/archive/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc devtools"

RDEPEND="
	>=dev-games/mygui-3.2.1
	>=dev-libs/boost-1.46.0
	>=dev-qt/qtcore-5.5.0:5
	>=dev-qt/qtgui-5.5.0:5
	>=sci-physics/bullet-2.80
	app-arch/unshield
	dev-games/openscenegraph[jpeg,png,qt5]
	dev-libs/tinyxml
	devtools? ( dev-qt/qtxmlpatterns:5 )
	media-fonts/dejavu
	media-libs/libsdl2[X,video]
	media-libs/libtxc_dxtn
	media-libs/openal
	virtual/ffmpeg
	"
#	x11-themes/tango-icon-theme
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen media-gfx/graphviz )"

S=${WORKDIR}/${PN}-${P}

PATCHES=(
	"${FILESDIR}/${PN}-0.37.0-MyGUI-lib-dir.patch"
	"${FILESDIR}/${PN}-0.29.0-use_system_fonts.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_BSATOOL="$(usex devtools)"
		-DBUILD_ESMTOOL="$(usex devtools)"
		-DBUILD_OPENCS="$(usex devtools)"
		-DBUILD_OPENMW=ON
		-DBUILD_UNITTESTS=OFF
		-DCMAKE_BUILD_TYPE=Release
		-DDATADIR="/usr/share/${PN}"
		-DDESIRED_QT_VERSION=5
		-DGLOBAL_CONFIG_PATH="/etc"
		-DICONDIR="/usr/share/icons/hicolor/256x256/apps"
		-DMORROWIND_DATA_FILES="/usr/share/${PN}/data"
		-DOPENMW_RESOURCE_FILES="/usr/share/${PN}/resources"
		-DUSE_SYSTEM_TINYXML=TRUE
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use doc ; then
		emake -C "${CMAKE_BUILD_DIR}" doc
	fi
}

src_install() {
	cmake-utils_src_install
	dodoc README.md

	# about 46835 files, dodoc seems to have trouble
	if use doc ; then
		dodir "/usr/share/doc/${PF}"
		find "${CMAKE_BUILD_DIR}"/docs/Doxygen/html \
			-name '*.md5' -type f -delete
		mv "${CMAKE_BUILD_DIR}"/docs/Doxygen/html \
			"${D}/usr/share/doc/${PF}/" || die
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update

	elog "You need the original Morrowind Data files. If you haven't"
	elog "installed them yet, you can install them straight via the"
	elog "installation wizard which is the officially"
	elog "supported method (either by using the launcher or by calling"
	elog "'openmw-wizard' directly)."
}

pkg_postrm() {
	gnome2_icon_cache_update
}
