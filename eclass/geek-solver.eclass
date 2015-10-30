# Copyright 1999-2015 The Bentoo Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v3 or later
# $Header: $

# @ECLASS: geek-solver.eclass
# This file is part of sys-kernel/geek-sources project.
# @MAINTAINER:
# Andrey Ovcharov <sudormrfhalt@gmail.com>
# @AUTHOR:
# Original author: Andrey Ovcharov <sudormrfhalt@gmail.com> (19 Nov 2013)
# @LICENSE: http://www.gnu.org/licenses/gpl-3.0.html GNU GPL v3
# @BLURB: Eclass for solve patch versions problem.
# @DESCRIPTION:
# This eclass provides functionality and default ebuild variables for solve
# problems with versions of the patches

# The latest version of this software can be obtained here:
# https://github.com/init6/init_6/blob/master/eclass/geek-solver.eclass
# Bugs: https://github.com/init6/init_6/issues
# Wiki: https://github.com/init6/init_6/wiki/geek-sources

#inherit patch utils vars

#EXPORT_FUNCTIONS mlsr_sort vercmp

function version_comparator() {
	# the main idea of the algorithm by megabaks https://www.linux.org.ru/people/megabaks/profile
	# adaptation, minor fixes and tests init_6

	# 0 >>> "${1}" = "${2}"
	# 1 >>> "${1}" > "${2}"
	# 2 >>> "${2}" > "${1}"

	# alpha < beta
	# beta < pre
	# pre < rc
	# rc < p
	# none  < p

#	debug-print-function ${FUNCNAME} "$@"

	[[ ${#} -ne 2 ]] && die "Invalid number of args to ${FUNCNAME}()";

	local alpha="0.1."
	local beta="0.2."
	local pre="0.3."
	local rc="0.4."
	local p="1.5."
	local x="1.0"

	[[ "${1}" == "${2}" ]] && return "0" && exit 0

	local f_ver="${1}"
	local s_ver="${2}"
	local f_striped="${f_ver%_*}"
	local s_striped="${s_ver%_*}"
	local f_test="${f_ver#${f_striped}_}" && [[ "${f_test}" == "${f_ver}" ]] && unset f_test
	local s_test="${s_ver#${s_striped}_}" && [[ "${s_test}" == "${s_ver}" ]] && unset s_test

	if [[ "${f_striped}" != "${s_striped}" ]];then
		biggest="$(echo -e "${f_striped}\n${s_striped}" | sort -t '.' -k 1,1 | tail -n1)"
		[[ "${biggest}" == "${f_striped}" ]] && return "1" || return "2"
		exit 0
	elif [[ "${f_test}" != "${s_test}" ]];then
		for i in alpha beta pre rc p;do
		f_test="${f_test/${i}/$(eval echo \$${i})}"
		s_test="${s_test/${i}/$(eval echo \$${i})}"
		done
		f_test="${f_test:-${x}}"
		s_test="${s_test:-${x}}"
		biggest="$(echo -e "${f_test}\n${s_test}" | sort -t '.' -k 1,1 | tail -n1)"
		[[ "${biggest}" == "${f_test}" ]] && return "1" || return "2"
		exit 0
	fi
}

# function geek-solver_vercmp() {
function vercmp() {
#	debug-print-function ${FUNCNAME} "$@"

	[[ ${#} -ne 3 ]] && die "Invalid number of args to ${FUNCNAME}()";

	version_comparator "$1" "$3"
	case "$2" in
		"=" ) (( $? == 0 ));;
		"<" ) (( $? == 2 ));;
		">" ) (( $? == 1 ));;
		* ) ewarn "Unrecognised version comparator: $2" >&2
	esac
}
