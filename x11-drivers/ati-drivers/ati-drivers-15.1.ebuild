# Copyright 1999-2016 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

EAPI=5

MULTILIB_COMPAT=( abi_x86_{32,64} )
inherit eutils multilib-build linux-info linux-mod toolchain-funcs versionator pax-utils

DESCRIPTION="Ati precompiled drivers for Radeon Evergreen (HD5000 Series) and newer chipsets"
HOMEPAGE="http://www.amd.com"
#RUN="${WORKDIR}/fglrx-14.501.1003/amd-driver-installer-14.501.1003-x86.x86_64.run"
SLOT="1"
# Uses javascript for download YESSSS
#DRIVERS_URI="http://www2.ati.com/drivers/linux/amd-catalyst-13.12-linux-x86.x86_64.zip"
DRIVERS_URI="mirror://ubuntu/pool/restricted/f/fglrx-installer/fglrx-installer_15.200.orig.tar.gz"
XVBA_SDK_URI="http://developer.amd.com/wordpress/media/2012/10/xvba-sdk-0.74-404001.tar.gz"
SRC_URI="${DRIVERS_URI} ${XVBA_SDK_URI}"
FOLDER_PREFIX="common/"
IUSE="debug static-libs pax_kernel"

LICENSE="AMD GPL-2 QPL-1.0"
KEYWORDS="-* ~amd64 ~x86"

RESTRICT="bindist test"

RDEPEND="
	~x11-drivers/ati-userspace-${PV}
"
if [[ legacy != ${SLOT} ]]; then
	RDEPEND="${RDEPEND}
		!x11-drivers/ati-drivers:legacy"
else
	RDEPEND="${RDEPEND}
		!x11-drivers/ati-drivers:1"
fi

DEPEND="${RDEPEND}
	x11-proto/inputproto
	x11-proto/xf86miscproto
	x11-proto/xf86vidmodeproto
	x11-proto/xineramaproto
	x11-libs/libXtst
	sys-apps/findutils
	app-misc/pax-utils
	app-arch/unzip
"

EMULTILIB_PKG="true"

S="${WORKDIR}"

pkg_pretend() {
	local CONFIG_CHECK="~MTRR ~!DRM ACPI PCI_MSI !LOCKDEP !PAX_KERNEXEC_PLUGIN_METHOD_OR"
	use amd64 && CONFIG_CHECK+=" COMPAT"

	local ERROR_MTRR="CONFIG_MTRR required for direct rendering."
	local ERROR_DRM="CONFIG_DRM must be disabled or compiled as a module and not loaded for direct
		rendering to work."
	local ERROR_LOCKDEP="CONFIG_LOCKDEP (lock tracking) exports the symbol lock_acquire
		as GPL-only. This prevents ${P} from compiling with an error like this:
		FATAL: modpost: GPL-incompatible module fglrx.ko uses GPL-only symbol 'lock_acquire'"
	local ERROR_PAX_KERNEXEC_PLUGIN_METHOD_OR="This config option will cause
		kernel to reject loading the fglrx module with
		\"ERROR: could not insert 'fglrx': Exec format error.\"
		You may want to try CONFIG_PAX_KERNEXEC_PLUGIN_METHOD_BTS instead."
	local ERROR_BKL="CONFIG_BKL must be enabled for kernels 2.6.37-2.6.38."

	if ! has XT ${PAX_MARKINGS} && use pax_kernel; then
		ewarn "You have disabled xattr pax markings for portage."
		ewarn "This will likely cause programs using ati-drivers provided"
		ewarn "libraries to be killed kernel."
	fi
}

pkg_setup() {
	MODULE_NAMES="fglrx(video:${S}/${FOLDER_PREFIX}/lib/modules/fglrx/build_mod/2.6.x)"
	BUILD_TARGETS="kmod_build"
	linux-mod_pkg_setup
	BUILD_PARAMS="GCC_VER_MAJ=$(gcc-major-version) KVER=${KV_FULL} KDIR=${KV_OUT_DIR}"
	BUILD_PARAMS="${BUILD_PARAMS} CFLAGS_MODULE+=\"-DMODULE -DATI -DFGL\""
	if grep -q arch_compat_alloc_user_space ${KV_DIR}/arch/x86/include/asm/compat.h ; then
		BUILD_PARAMS="${BUILD_PARAMS} CFLAGS_MODULE+=-DCOMPAT_ALLOC_USER_SPACE=arch_compat_alloc_user_space"
	else
		BUILD_PARAMS="${BUILD_PARAMS} CFLAGS_MODULE+=-DCOMPAT_ALLOC_USER_SPACE=compat_alloc_user_space"
	fi

	# Define module dir.
	MODULE_DIR="${S}/${FOLDER_PREFIX}/lib/modules/fglrx/build_mod"
	# get the xorg-server version and set BASE_DIR for that
	BASE_DIR="${S}/xpic"

	# amd64/x86
	if use amd64 ; then
		MY_BASE_DIR="${BASE_DIR}_64a"
		PKG_LIBDIR=lib64
		ARCH_DIR="${S}/arch/x86_64"
	else
		MY_BASE_DIR="${BASE_DIR}"
		PKG_LIBDIR=lib
		ARCH_DIR="${S}/arch/x86"
	fi

	elog
	elog "Please note that this driver only supports graphic cards based on"
	elog "Evergreen chipset and newer."
	elog "This includes the AMD Radeon HD 5400+ series at this moment."
	elog
	elog "If your card is older then use ${CATEGORY}/xf86-video-ati"
	elog "For migration informations please refer to:"
	elog "http://www.gentoo.org/proj/en/desktop/x/x11/ati-migration-guide.xml"
	einfo
}

src_unpack() {
	local DRIVERS_DISTFILE XVBA_SDK_DISTFILE
	DRIVERS_DISTFILE=${DRIVERS_URI##*/}
	XVBA_SDK_DISTFILE=${XVBA_SDK_URI##*/}

	if [[ ${DRIVERS_DISTFILE} =~ .*\.tar\.gz ]]; then
		unpack ${DRIVERS_DISTFILE}
		mkdir -p common
		mv etc lib usr common || die "Assumed to find etc lib and usr for common"
	else
		#please note, RUN may be insanely assigned at top near SRC_URI
		if [[ ${DRIVERS_DISTFILE} =~ .*\.zip ]]; then
			unpack ${DRIVERS_DISTFILE}
			[[ -z "$RUN" ]] && RUN="${S}/${DRIVERS_DISTFILE/%.zip/.run}"
		else
			RUN="${DISTDIR}/${DRIVERS_DISTFILE}"
		fi
		sh "${RUN}" --extract "${S}" 2>&1 > /dev/null || die
	fi

	mkdir xvba_sdk
	cd xvba_sdk
	unpack ${XVBA_SDK_DISTFILE}

	mkdir -p "${WORKDIR}/extra" || die "mkdir extra failed"
	cd "${WORKDIR}/extra"
	tar -xf "../${FOLDER_PREFIX}usr/src/ati/fglrx_sample_source.tgz"
}

src_prepare() {
	if use debug; then
		sed -i '/^#define DRM_DEBUG_CODE/s/0/1/' \
			"${MODULE_DIR}/firegl_public.c" \
			|| die "Failed to enable debug output."
	fi


	# These are the userspace utilities that we also have source for.
	# We rebuild these later.
	rm \
		"${ARCH_DIR}"/usr/X11R6/bin/fgl_glxgears \
		|| die "bin rm failed"

	# ACPI fixups
	sed -i \
		-e "s:/var/lib/xdm/authdir/authfiles/:/var/run/xauth/:" \
		-e "s:/var/lib/gdm/:/var/gdm/:" \
		"${S}/${FOLDER_PREFIX}etc/ati/authatieventsd.sh" \
		|| die "ACPI fixups failed."

	# Since "who" is in coreutils, we're using that one instead of "finger".
	sed -i -e 's:finger:who:' \
		"${S}/${FOLDER_PREFIX}usr/share/doc/fglrx/examples/etc/acpi/ati-powermode.sh" \
		|| die "Replacing 'finger' with 'who' failed."
	# Adjust paths in the script from /usr/X11R6/bin/ to /opt/bin/ and
	# add function to detect default state.
	epatch "${FILESDIR}"/ati-powermode-opt-path-3.patch

	# see http://ati.cchtml.com/show_bug.cgi?id=495
	#epatch "${FILESDIR}"/ati-drivers-old_rsp.patch
	# first hunk applied upstream second (x32 related) was not
	epatch "${FILESDIR}"/ati-drivers-x32_something_something.patch

	# compile fix for AGP-less kernel, bug #435322
	epatch "${FILESDIR}"/ati-drivers-12.9-KCL_AGP_FindCapsRegisters-stub.patch

	epatch "${FILESDIR}/ati-drivers-13.8-beta-include-seq_file.patch"

	# Fix #483400
	epatch "${FILESDIR}/fgl_glxgears-do-not-include-glATI.patch"

	# Compile fix, https://bugs.gentoo.org/show_bug.cgi?id=454870
	use pax_kernel && epatch "${FILESDIR}/const-notifier-block.patch"

	# Compile fix, #526602
	epatch "${FILESDIR}/use-kernel_fpu_begin.patch"


	# Linux < 4.0 support
	epatch "${FILESDIR}/${PN}-linux-4.0.patch"

	# Linux 4.0, 4.1 support
	if kernel_is ge 3 18; then
		epatch "${FILESDIR}/${P}-linux-3.19-4.0.patch"
	fi

	if kernel_is ge 4 1; then
		epatch "${FILESDIR}/${PN}-linux-4.1.patch"
	fi

	cd "${MODULE_DIR}"

	# bugged fglrx build system, this file should be copied by hand
	cp ${ARCH_DIR}/lib/modules/fglrx/build_mod/libfglrx_ip.a 2.6.x

	convert_to_m 2.6.x/Makefile || die "convert_to_m failed"

	# When built with ati's make.sh it defines a bunch of macros if
	# certain .config values are set, falling back to less reliable
	# detection methods if linux/autoconf.h is not available. We
	# simply use the linux/autoconf.h settings directly, bypassing the
	# detection script.
	sed -i -e 's/__SMP__/CONFIG_SMP/' *.c *h || die "SMP sed failed"
	sed -i -e 's/ifdef MODVERSIONS/ifdef CONFIG_MODVERSIONS/' *.c *.h \
		|| die "MODVERSIONS sed failed"
}

src_compile() {
	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install
}

pkg_postinst() {
	elog "To switch to AMD OpenGL, run \"eselect opengl set ati\""
	elog "To change your xorg.conf you can use the bundled \"aticonfig\""
	elog
	elog "If you experience unexplained segmentation faults and kernel crashes"
	elog "with this driver and multi-threaded applications such as wine,"
	elog "set UseFastTLS in xorg.conf to either 0 or 1, but not 2."
	elog
	elog "Fully rebooting the system after an ${PN} update is recommended"
	elog "Stopping Xorg, reloading fglrx kernel module and restart Xorg"
	elog "might not work"
	elog
	elog "Some cards need acpid running to handle events"
	elog "Please add it to boot runlevel with rc-update add acpid boot"
	elog
	linux-mod_pkg_postinst
}

pkg_prerm() {
	"${ROOT}"/usr/bin/eselect opengl set --use-old xorg-x11
}

pkg_preinst() {
	linux-mod_pkg_preinst
}

pkg_postrm() {
	linux-mod_pkg_postrm
}
