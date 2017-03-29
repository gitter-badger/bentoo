# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
PYTHON_COMPAT=( python3_4 )

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/apple/swift
	https://github.com/apple/swift-llvm
	https://github.com/apple/swift-clang
	https://github.com/apple/swift-lldb
	https://github.com/apple/swift-cmark
	https://github.com/apple/swift-llbuild
	https://github.com/apple/swift-package-manager
	https://github.com/apple/swift-corelibs-xctest
	https://github.com/apple/swift-corelibs-foundation
	https://github.com/apple/swift-corelibs-libdispatch
	https://github.com/apple/swift-integration-tests"
else
	RESTRICT="mirror"
	MY_P="${PV}-RELEASE"
	SRC_URI="https://github.com/apple/swift/archive/swift-${MY_P}.tar.gz -> swift-${MY_P}.tar.gz
	https://github.com/apple/swift-llvm/archive/swift-${MY_P}.tar.gz -> swift-llvm-${MY_P}.tar.gz
    https://github.com/apple/swift-clang/archive/swift-${MY_P}.tar.gz -> swift-clang-${MY_P}.tar.gz
	https://github.com/apple/swift-lldb/archive/swift-${MY_P}.tar.gz -> swift-lldb-${MY_P}.tar.gz
	https://github.com/apple/swift-cmark/archive/swift-${MY_P}.tar.gz -> swift-cmark-${MY_P}.tar.gz
	https://github.com/apple/swift-llbuild/archive/swift-${MY_P}.tar.gz -> swift-llbuild-${MY_P}.tar.gz
	https://github.com/apple/swift-package-manager/archive/swift-${MY_P}.tar.gz -> swift-package-manager-${MY_P}.tar.gz
	https://github.com/apple/swift-corelibs-xctest/archive/swift-${MY_P}.tar.gz -> swift-corelibs-xctest-${MY_P}.tar.gz
	https://github.com/apple/swift-corelibs-foundation/archive/swift-${MY_P}.tar.gz -> swift-corelibs-foundation-${MY_P}.tar.gz
	https://github.com/apple/swift-corelibs-libdispatch/archive/swift-${MY_P}.tar.gz -> swift-corelibs-libdispatch-${MY_P}.tar.gz
	https://github.com/apple/swift-integration-tests/archive/swift-${MY_P}.tar.gz -> swift-integration-tests-${MY_P}.tar.gz"
fi

inherit autotools python-single-r1 eutils

DESCRIPTION="The Swift programming language and debugger"
HOMEPAGE="https://swift.org"

LICENSE="Apache-2.0"
SLOT=0
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-db/sqlite
	dev-libs/icu
	dev-libs/libbsd
	dev-libs/libedit
	dev-libs/libxml2
	dev-python/six[${PYTHON_USEDEP}]
	sys-apps/util-linux
	>=sys-libs/ncurses-5.9-r3:5/5[tinfo,abi_x86_32(-)]"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-vcs/git
	>=sys-devel/clang-3.6
	dev-util/ninja
	dev-lang/swig
	dev-lang/perl
	dev-python/sphinx
	sys-devel/llvm[-lldb]"

DOCS=( LICENSE.txt  )

	# Prefer LZMA2 compression for smaller files. Merge request(s) upstream:
	# https://github.com/apple/swift/pull/801
	# 0001-build-script-Reduce-the-size-of-development-snapshot.patch

	# Sphinx 1.3.5 raises a warning (promoted to error) when using an unknown
	# syntax highlighting language (like "swift").
	# swift-sphinx2.patch

	# Typo in build-script
	# build-script.patch

	# Fix for missing initialization
	# swift-init-CachedVFile.patch

PATCHES=( "${FILESDIR}"/0001-build-script-Reduce-the-size-of-development-snapshot.patch
	"${FILESDIR}"/swift-sphinx2.patch
	"${FILESDIR}"/build-script.patch
	"${FILESDIR}"/swift-init-CachedVFile.patch )

S="${WORKDIR}"
CARCH=`uname -m`

src_prepare() {
	# Use directory names which build-script expects
	for sdir in llvm lldb clang cmark; do
		ln -sf swift-${sdir}-swift-${MY_P} ${sdir}
	done
	ln -sf swift-swift-${MY_P} swift

	for sdir in corelibs-xctest corelibs-foundation corelibs-libdispatch integration-tests; do
		ln -sf swift-${sdir}-swift-${MY_P} swift-${sdir}
	done
	ln -sf swift-llbuild-swift-${MY_P} llbuild
	ln -sf swift-package-manager-swift-${MY_P} swiftpm

	cd "${S}/swift"

	if declare -p PATCHES | grep -q "^declare -a "; then
		[[ -n ${PATCHES[@]} ]] && for i in "${PATCHES[@]}"; do ipatch push . "$i"; done
	else
		[[ -n ${PATCHES} ]] && ipatch push . "${PATCHES}"
	fi
	cd ..

	cd "${S}/lldb"
	ipatch push . "${FILESDIR}"/fix-lldb-build.patch
	cd ..

	eapply_user
}

src_compile(){
	export LC_CTYPE=en_US.UTF-8
	export LANG=en_US.UTF-8
	installable_package="$(readlink -f ${S}/swift-${MY_P}.tar.xz)"
	cd "${S}/swift"
#   export SWIFT_SOURCE_ROOT="${S}"
#	export LDFLAGS='-ldl -lpthread'
	utils/build-script \
		--preset-file="${FILESDIR}/build-presets.ini" \
		--preset=buildbot_bentoo_linux \
		installable_package="${installable_package}" \
		install_destdir="${D}/"
}

src_test() {
	cd "${S}/swift"

    export SWIFT_SOURCE_ROOT="${S}"
	utils/build-script -R -t
}

src_install() {
    cd "${S}/build/Ninja-ReleaseAssert"

    install -dm755 "${D}/usr/bin"
	install -dm755 "${D}/usr/$(get_libdir)/swift"

    # Swift's components don't provide an install target :(
    # These are based on what's included in the binary release packages

	cd swift-linux-$CARCH
	install -m755 bin/swift bin/swift-{demangle,ide-test} "${D}/usr/bin"
	ln -s swift "${D}/usr/bin/swiftc"
	ln -s swift "${D}/usr/bin/swift-autolink-extract"

	install -dm755 "${D}/usr/share/man/man1"
	install -m644 docs/tools/swift.1 "${D}/usr/share/man/man1"

	umask 0022
	cp -rL $(get_libdir)/swift/{clang,linux,shims} "${D}/usr/$(get_libdir)/swift/"

	# build lldb only when requested
	cd lldb-linux-$CARCH
	DESTDIR="${D}" ninja install

	cd llbuild-linux-$CARCH
	install -m755 bin/swift-build-tool "${D}/usr/bin"

	cd swiftpm-linux-$CARCH
	install -m755 debug/swift-{build,test,package} "${D}/usr/bin"

	install -dm755 "${D}/usr/$(get_libdir)/swift/pm"
	install -m755 $(get_libdir)/swift/pm/libPackageDescription.so "${D}/usr/$(get_libdir)/swift/pm"
	install -m644 $(get_libdir)/swift/pm/PackageDescription.swiftmodule "${D}/usr/$(get_libdir)/swift/pm"

	cd foundation-linux-$CARCH
	install -m755 Foundation/libFoundation.so "{D}/usr/$(get_libdir)/swift/linux/"
	install -m644 Foundation/Foundation.swiftdoc "${D}/usr/$(get_libdir)/swift/linux/$CARCH"
	install -m644 Foundation/Foundation.swiftmodule "${D}/usr/$(get_libdir)/swift/linux/$CARCH"

	umask 0022
	cp -r Foundation/usr/$(get_libdir)/swift/CoreFoundation "${D}/usr/$(get_libdir)/swift/"

	cd xctest-linux-$CARCH
	install -m755 libXCTest.so "${D}/usr/$(get_libdir)/swift/linux/"
	install -m644 XCTest.swiftdoc "${D}/usr/$(get_libdir)/swift/linux/$CARCH"
	install -m644 XCTest.swiftmodule "${D}/usr/$(get_libdir)/swift/linux/$CARCH"

	cd libdispatch-linux-$CARCH
	make install DESTDIR="$D"

	install -dm755 "$D/usr/share/licenses/swift"
	install -m644 "$S/swift/LICENSE.txt" "$D/usr/share/licenses/swift"
}
