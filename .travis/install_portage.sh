#!/bin/bash -

[ -z "${PORTAGE_ROOT}" ] && { echo "PORTAGE_ROOT not set"; exit 1; }
mkdir -v -p "${PORTAGE_ROOT}"
[ -z "${PORTAGE_VER}" ] && { echo "PORTAGE_VER not set"; exit 1; }
[ -z "${REPOMAN_VER}" ] && { echo "REPOMAN_VER not set"; exit 1; }
: ${OVERLAY_NAME:=${TRAVIS_REPO_SLUG##*/}}

# die on failure
set -e

source "$(dirname "${BASH_SOURCE[0]}")/travis-functions.sh" || exit 1


get_archive() {
    local url="${1?}" dir="${2?}"
    local tmpd="$(mktemp -d)" file="${url##*/}"

    pushd "${tmpd}" >/dev/null

    wget "$url" -O "${file}" || return 1
    mkdir -p "${dir}"
    tar xf "${file}" -C "${dir}" --strip-components=1 || return 2

    popd >/dev/null
    rm -r "${tmpd}"
}


## prepare env
## ------------
fold_start environment "Prepare environment"

PORTAGE_REPOS_DIR="${PORTAGE_ROOT}/usr/portage"   && mkdir -v -p "${PORTAGE_REPOS_DIR}"
PORTAGE_CONF_DIR="${PORTAGE_ROOT}/etc/portage"  && mkdir -v -p "${PORTAGE_CONF_DIR}"
DISTDIR="$(mktemp -d --suffix=-DISTDIR)"        && echo "DISTDIR: ${DISTDIR}"

mkdir -v -p "${PORTAGE_ROOT}/usr/lib64"
ln -v -s 'lib64' "${PORTAGE_ROOT}/usr/lib"

fold_end environment


run_module() {
    local mod_name="$1"

    local WORKDIR="$(mktemp -d --suffix=-WORKDIR)"
    local S="${WORKDIR}/${mod_name}"

    pushd "${WORKDIR}" >/dev/null

    local phases=(
        setup
        fetch
        prepare
        configure
        compile
        preinst
        install
        postinst
    )

    # run in a subshell in order to sandbox environment
    (
    fold_start "${mod_name}" "Running module '${mod_name}'"

    for ph in "${phases[@]}" ; do
        local fn="${mod_name}:${ph}"

        [[ "${ph}" == prepare ]] && [[ -d "${S}" ]] && cd "${S}"

        if declare -f "${fn}" >/dev/null ; then
            fold_start "${fn//:/.}" "${ph^}"
            "${fn}"
            fold_end "${fn//:/.}"
        fi
    done

    fold_end "${mod_name}"
    )

    popd >/dev/null
    rm -r "${WORKDIR}"
}

## BEGIN -- portage -----------------------------------------------------------

portage:fetch() {
    get_archive \
            "https://github.com/gentoo/portage/archive/portage-${PORTAGE_VER}.tar.gz" \
            "${S}"
}

portage:install() {
    local args=(
        -O2
        --system-prefix="${PORTAGE_ROOT}/usr"
        --sysconfdir="${PORTAGE_ROOT}/etc"
    )
    ./setup.py install "${args[@]}"
}

## END -- portage -------------------------------------------------------------

## BEGIN -- repoman -----------------------------------------------------------

repoman:fetch() {
    get_archive \
            "https://github.com/gentoo/portage/archive/repoman-${REPOMAN_VER}.tar.gz" \
            "${S}"
    S+="/repoman"
}

repoman:prepare() {
    # allow to have arbitrary copyright holder name and deprecate $Id$ header
    sed -e 's|if num > 2:|if num >= 0:|' \
        -i -- pym/repoman/modules/scan/ebuild/checks.py
}

repoman:install() {
    local args=(
        -O2
        --system-prefix="${PORTAGE_ROOT}/usr"
        --sysconfdir="${PORTAGE_ROOT}/etc"
    )
    ./setup.py install "${args[@]}"
}

repoman:postinst() {
    wget 'https://www.gentoo.org/dtd/metadata.dtd' -P "${DISTDIR}/"
}

## END -- repoman -------------------------------------------------------------

## BEGIN -- repos -------------------------------------------------------------

# declaration inside a function doesn't work
declare -g -A REPOS=(
    [gentoo]='https://github.com/gentoo-mirror/gentoo/archive/master.tar.gz'
)

repos:fetch() {
    local r
    for r in "${!REPOS[@]}" ; do
        get_archive \
            "${REPOS[${r}]}" \
            "${S}/${r}"
    done
}

repos:install() {
    local r
    for r in "${!REPOS[@]}" ; do
        mv -v "${r}" "${PORTAGE_REPOS_DIR}/"
    done
}

repos:postinst() {
    mkdir -v -p "${PORTAGE_CONF_DIR}/repos.conf"

    announce tee "${PORTAGE_CONF_DIR}/repos.conf/default" <<-_EOF_
    [DEFAULT]
    main-repo = gentoo
_EOF_

    announce tee "${PORTAGE_CONF_DIR}/repos.conf/${OVERLAY_NAME}" <<-_EOF_
    [${OVERLAY_NAME}]
    location = ${TRAVIS_BUILD_DIR}
_EOF_

    local r
    for r in "${!REPOS[@]}" ; do
        announce tee "${PORTAGE_CONF_DIR}/repos.conf/${r}" <<-_EOF_
        [${r}]
        location = ${PORTAGE_REPOS_DIR}/${r}
_EOF_
    done
}

## END -- repos ---------------------------------------------------------------

run_module portage
run_module repoman
run_module repos

## install portage configs
## ------------------------
fold_start configuration "Configure"

announce tee "${PORTAGE_CONF_DIR}/make.conf" << _EOF_
DISTDIR="${DISTDIR}"
PKGDIR="$(mktemp -d --suffix=-PKGDIR)"
PORTAGE_TMPDIR="$(mktemp -d --suffix=-PORTAGE_TMPDIR)"
RPMDIR="$(mktemp -d --suffix=-RPMDIR)"
_EOF_

mkdir -p "${PORTAGE_CONF_DIR}/make.profile"
announce tee "${PORTAGE_CONF_DIR}/make.profile/parent" << _EOF_
gentoo:base
gentoo:arch/base
gentoo:default/linux
gentoo:targets/systemd
bentoo:
_EOF_

fold_end configuration
