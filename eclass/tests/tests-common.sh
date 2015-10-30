#!/usr/bin/env bash

# Copyright 2013-2014 Andrey Ovcharov <sudormrfhalt@gmail.com>
# Distributed under the terms of the GNU General Public License v3
# $Header: $

# tests-common.sh Unit Tests Lib
# This file is part of sys-kernel/geek-sources project.

if ! source /usr/lib64/misc/core-functions.sh ; then
	echo "Missing core-functions.sh. Please to install!" 1>&2
	exit 1
fi

etest() {
	ebegin "$1"
	eindent
	local pass=0 fail=0 res=false
	$1

	einfo "Passed: ${pass}, Failed: ${fail}"
	[[ ${fail} -eq 0 ]] && res=true
	if ${res}; then
		let PASSING++
		eend 0
	else
		let FAILING++
		eend 1
	fi
	eoutdent
}

inherit() {
	local e
	for e in "$@" ; do
		source ../${e}.eclass # 2&>/dev/null
	done
}

EXPORT_FUNCTIONS() { :; }

die() {
	return
}

use() {
	local u=$1
	local found=0

	# if we got something like '!flag', then invert the return value
	if [[ ${u:0:1} == "!" ]] ; then
		u=${u:1}
		found=1
	fi

	# Make sure we have this USE flag in IUSE
	if [[ -n $PORTAGE_IUSE ]] ; then
		[[ $u =~ $PORTAGE_IUSE ]] || \
			echo "QA Notice: USE Flag '${u}' not" \
				"in IUSE for ${CATEGORY}/${PF}"
			exit
	fi

	if [[ ${USE} =~ -${u} ]]; then
		return $((!found))
	else
		return ${found}
	fi
}
