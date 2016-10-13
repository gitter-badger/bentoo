# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Id$

EAPI="6"
PYTHON_COMPAT=( python2_7 )

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/apple/swift
	https://github.com/apple/swift-llvm
	https://github.com/apple/swift-clang
	lldb? ( https://github.com/apple/swift-lldb )
	https://github.com/apple/swift-cmark
	experimental? ( https://github.com/apple/swift-llbuild
	https://github.com/apple/swift-package-manager
	https://github.com/apple/swift-corelibs-xctest
	https://github.com/apple/swift-corelibs-foundation )"
else
	RESTRICT="mirror"
	MY_P="${PV}-RELEASE"
	MY_OP="2.2-SNAPSHOT-2016-01-11-a"
	SRC_URI="https://github.com/apple/swift/archive/swift-${MY_P}.tar.gz -> swift-${MY_P}.tar.gz
	https://github.com/apple/swift-llvm/archive/swift-${MY_P}.tar.gz -> swift-llvm-${MY_P}.tar.gz
    	https://github.com/apple/swift-clang/archive/swift-${MY_P}.tar.gz -> swift-clang-${MY_P}.tar.gz
    	lldb? ( https://github.com/apple/swift-lldb/archive/swift-${MY_P}.tar.gz -> swift-lldb-${MY_P}.tar.gz  )
	https://github.com/apple/swift-cmark/archive/swift-${MY_P}.tar.gz -> swift-cmark-${MY_P}.tar.gz
	experimental? ( https://github.com/apple/swift-llbuild/archive/swift-${MY_OP}.tar.gz -> swift-llbuild-${MY_OP}.tar.gz
	https://github.com/apple/swift-package-manager/archive/swift-${MY_OP}.tar.gz -> swift-package-manager-${MY_OP}.tar.gz
	https://github.com/apple/swift-corelibs-xctest/archive/swift-${MY_OP}.tar.gz -> swift-corelibs-xctest-${MY_OP}.tar.gz
	https://github.com/apple/swift-corelibs-foundation/archive/swift-${MY_OP}.tar.gz -> swift-corelibs-foundation-${MY_OP}.tar.gz )"
fi

inherit autotools python-single-r1

DESCRIPTION="The Swift programming language and debugger"
HOMEPAGE="https://swift.org"

LICENSE="Apache-2.0"
SLOT=2
KEYWORDS="-*"
IUSE="experimental lldb"

RDEPEND="dev-db/sqlite
	dev-libs/icu
	dev-libs/libbsd
	dev-libs/libedit
	dev-libs/libxml2
	dev-python/six[${PYTHON_USEDEP}]
	sys-apps/util-linux
	>=sys-libs/ncurses-5.9:5[tinfo]"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-vcs/git
	>=sys-devel/clang-3.6
	dev-util/ninja
	dev-lang/swig
	dev-lang/perl
	lldb? ( sys-devel/llvm[-lldb] )"

DOCS=( LICENSE.txt  )

# Sphinx 1.3.5 raises a warning (promoted to error) when using an unknown
# syntax highlighting language (like "swift").

# Recent versions of pod2man require an argument to --release.  If no
# argument is provided, it will treat the next option as its argument,
# thereby breaking all subsequent arguments.  So let's put something
# useful there instead :)

PATCHES=( "${FILESDIR}"/swift-sphinx2.patch "${FILESDIR}"/pod2man_release.patch )

S="${WORKDIR}"
CARCH=`uname -m`

src_prepare() {
    # Use python2 where appropriate
	find "${S}" -type f -print0 | \
		xargs -0 sed -i 's|/usr/bin/env python$|&2|'
	sed -i '/^cmake_minimum_required/a set(Python_ADDITIONAL_VERSIONS 2.7)' \
		"${S}/swift-swift-${MY_P}/CMakeLists.txt"
	if use lldb; then
		find "${S}/swift-lldb-swift-${MY_P}" -name Makefile -print0 | \
			xargs -0 sed -i 's|python-config|python2-config|g'
		sed -i '/^cmake_minimum_required/a set(Python_ADDITIONAL_VERSIONS 2.7)' \
			"${S}/swift-lldb-swift-${MY_P}/CMakeLists.txt"
	fi
	sed -i 's/\<python\>/&2/' \
		"${S}/swift-swift-${MY_P}/utils/build-script-impl"

	# Fix bad include paths
#	find "${S}" -type f -print0 | \
#		 xargs -0 sed -i 's|/usr/include/x86_64-linux-gnu|/usr/include|g'

    # Use directory names which build-script expects
	for sdir in llvm clang cmark; do
		ln -sf swift-${sdir}-swift-${MY_P} ${sdir}
	done
	if use lldb; then
		ln -sf swift-lldb-swift-${MY_P} lldb
	fi
	ln -sf swift-swift-${MY_P} swift
	if use experimental; then
		for sdir in corelibs-xctest corelibs-foundation; do
			ln -sf swift-${sdir}-swift-${MY_OP} swift-${sdir}
		done
		ln -sf swift-llbuild-swift-${MY_OP} llbuild
		ln -sf swift-package-manager-swift-${MY_OP} swiftpm
	fi

	cd "${S}/swift"

	if declare -p PATCHES | grep -q "^declare -a "; then
		[[ -n ${PATCHES[@]}  ]] && eapply "${PATCHES[@]}"
	else
		[[ -n ${PATCHES}  ]] && eapply ${PATCHES}
	fi

	eapply_user
}

src_compile(){
	cd "${S}/swift"

    export SWIFT_SOURCE_ROOT="${S}"
	export LDFLAGS='-ldl -lpthread'
    # build lldb only when requested
	if use lldb; then
		BUILD_FLAGS=(--lldb)
	fi
	if use experimental; then
		BUILD_FLAGS+=(--llbuild --swiftpm --xctest --foundation)
	fi

	# build a release version (-R) instead of debug and use #CPU to build
	utils/build-script -R "${BUILD_FLAGS[@]}" \
		-j "$(lscpu --parse=CPU | grep -v '^#' | wc -l)"
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
	install -m755 bin/swift bin/swift-{demangle,compress,ide-test} "${D}/usr/bin"
	ln -s swift "${D}/usr/bin/swiftc"
	ln -s swift "${D}/usr/bin/swift-autolink-extract"

	install -dm755 "${D}/usr/share/man/man1"
	install -m644 docs/tools/swift.1 "${D}/usr/share/man/man1"

	umask 0022
	cp -rL $(get_libdir)/swift/{clang,glibc,linux,shims} "${D}/usr/$(get_libdir)/swift/"

	# build lldb only when requested
	if use lldb; then
    	cd lldb-linux-$CARCH
    	DESTDIR="${D}" ninja install
	fi

	if use experimental; then
		cd llbuild-linux-$CARCH
		install -m755 bin/swift-build-tool "${D}/usr/bin"

		cd swiftpm-linux-$CARCH
		install -m755 debug/swift-build "${D}/usr/bin"

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
	fi
}
