#!/usr/bin/env bash

# Copyright 2013-2014 Andrey Ovcharov <sudormrfhalt@gmail.com>
# Distributed under the terms of the GNU General Public License v3
# $Header: $

# geek-solver.eclass Unit Test
# This file is part of sys-kernel/geek-sources project.

source `pwd`/tests-common.sh

inherit geek-solver

test_vercmp_no_1() {
	echo "
	0		<	1
	1		<	2
	2		>	1
	2		=	2
	0		=	0
	10		<	20
	68		=	068
	068		>	67
	068		<	69

	1.0		<	2.0
	2.0		=	2.0
	2.0		>	1.0

	1.0		>	0.0
	0.0		=	0.0
	0.0		<	1.0

	0.1		<	0.2
	0.2		=	0.2
	0.3		>	0.2

	1.2		<	2.1
	2.1		>	1.2

	1.2.3		<	1.2.4
	1.2.4		>	1.2.3

	1.2.0		=	1.2
	1.2.1		>	1.2
	1.2		<	1.2.1

	1.2b		=	1.2b
	1.2b		<	1.2c
	1.2b		>	1.2a
	1.2b		>	1.2
	1.2		<	1.2a

	1.3		>	1.2a
	1.3		<	1.3a

	1.0_alpha7	<	1.0_beta7
	1.0_beta	<	1.0_pre
	1.0_pre5	<	1.0_rc2
	1.0_rc2		<	1.0

	1.0_p1		>	1.0
	1.0_p1-r1	>	1.0_p1

	1.0_alpha6-r1	>	1.0_alpha6
	1.0_beta6-r1	>	1.0_alpha6-r2

	1.0_pre1	<	1.0_p1

	1.0p		>	1.0_p1
	1.0r		>	1.0-r1
	1.6.15		>	1.6.10-r2
	1.6.10-r2	<	1.6.15

	" | while read a b c ; do
	[[ -z "${a}${b}${c}" ]] && continue

	ebegin "Testing \"${a} ${b} ${c}\""

	if vercmp "${a}" "${b}" "${c}"; then
		MY_P="Yes"
	else
		MY_P="No"
	fi

	if [[ ${MY_P} == "Yes" ]]; then
		let pass++
		eend 0
	else
		let fail++
		eend 1
	fi
	done
}

test_vercmp_no_2() {
	for q in "alpha beta pre rc=${lt};${gt}" "p=${gt};${lt}" ; do
		for p in ${q%%=*} ; do
#			vercmp "1.0" ">=" "1.0_${p}"
#			vercmp "1.0" ">=" "1.0_${p}1"
#			vercmp "1.0" ">=" "1.0_${p}068"

#			vercmp "2.0_${p}"    "<=" "2.0"
#			vercmp "2.0_${p}1"   "<=" "2.0"
#			vercmp "2.0_${p}068" "<=" "2.0"

			echo "
			1.0		>	1.0_${p}
			1.0		>	1.0_${p}1
			1.0		>	1.0_${p}068

			2.0_${p}	<	2.0
			2.0_${p}1	<	2.0
			2.0_${p}068	<	2.0

			1.0_${p}	=	1.0_${p}
			0.0_${p}	<	0.0_${p}1
			666_${p}3	>	666_${p}

			1_${p}7		<	1_${p}8
			1_${p}7		=	1_${p}7
			1_${p}7		>	1_${p}6
			1_${p}09	=	1_${p}9

			1_${p}7-r0	=	1_${p}7
			1_${p}7-r0	<	1_${p}7-r1
			1_${p}7-r0	<	1_${p}7-r01
			1_${p}7-r01	=	1_${p}7-r1
			1_${p}8-r1	>	1_${p}7-r100

			1_${p}_alpha	<	1_${p}_beta

			" | while read a b c ; do
			[[ -z "${a}${b}${c}" ]] && continue
			ebegin "Testing \"${a} ${b} ${c}\""

			if vercmp "${a}" "${b}" "${c}"; then
				MY_P="Yes"
			else
				MY_P="No"
			fi

			if [[ ${MY_P} == "Yes" ]]; then
				let pass++
				eend 0
			else
				let fail++
				eend 1
			fi
			done
		done
	done
}

test_vercmp_no_3() {
	for p in "-r" "_p" ; do
		echo "
		7.2${p}1	<	7.2${p}2
		7.2${p}2	>	7.2${p}1
		7.2${p}3	>	7.2${p}2
		7.2${p}2	<	7.2${p}3

		" | while read a b c ; do
		[[ -z "${a}${b}${c}" ]] && continue
		ebegin "Testing \"${a} ${b} ${c}\""

		if vercmp "${a}" "${b}" "${c}"; then
			MY_P="Yes"
		else
			MY_P="No"
		fi

		if [[ ${MY_P} == "Yes" ]]; then
			let pass++
			eend 0
		else
			let fail++
			eend 1
		fi
		done
	done
}

test_vercmp_no_4() {
	# The following tests all come from portage's test cases:
	echo "
	6.0		>	5.0
	5.0		>	5
	1.0-r1		>	1.0-r0
	1.0-r1		>	1.0
	999999999999999999999999999999		>	999999999999999999999999999998
	1.0.0		>	1.0
	1.0.0		>	1.0b
	1b		>	1
	1b_p1		>	1_p1
	1.1b		>	1.1
	12.2.5		>	12.2b

	" | while read a b c ; do
	[[ -z "${a}${b}${c}" ]] && continue
	ebegin "Testing \"${a} ${b} ${c}\""

	if vercmp "${a}" "${b}" "${c}"; then
		MY_P="Yes"
	else
		MY_P="No"
	fi

	if [[ ${MY_P} == "Yes" ]]; then
		let pass++
		eend 0
	else
		let fail++
		eend 1
	fi
	done
}

test_vercmp_no_5() {
	echo "
	4.0		<	5.0
	5		<	5.0
	1.0_pre2	<	1.0_p2
	1.0_alpha2	<	1.0_p2
	1.0_alpha1	<	1.0_beta1
	1.0_beta3	<	1.0_rc3
	1.001000000000000000001		<	1.001000000000000000002
	1.00100000000			<	1.0010000000000000001
	999999999999999999999999999998	<	999999999999999999999999999999
	1.01		<	1.1
	1.0-r0		<	1.0-r1
	1.0		<	1.0-r1
	1.0		<	1.0.0
	1.0b		<	1.0.0
	1_p1		<	1b_p1
	1		<	1b
	1.1		<	1.1b
	12.2b		<	12.2.5

	" | while read a b c ; do
	[[ -z "${a}${b}${c}" ]] && continue
	ebegin "Testing \"${a} ${b} ${c}\""

	if vercmp "${a}" "${b}" "${c}"; then
		MY_P="Yes"
	else
		MY_P="No"
	fi

	if [[ ${MY_P} == "Yes" ]]; then
		let pass++
		eend 0
	else
		let fail++
		eend 1
	fi
	done
}

test_vercmp_no_6() {
	echo "
	4.0	=	4.0
	1.0	=	1.0
	1.0-r0	=	1.0
	1.0	=	1.0-r0
	1.0-r0	=	1.0-r0
	1.0-r1	=	1.0-r1

	" | while read a b c ; do
	[[ -z "${a}${b}${c}" ]] && continue
	ebegin "Testing \"${a} ${b} ${c}\""

	if vercmp "${a}" "${b}" "${c}"; then
		MY_P="Yes"
	else
		MY_P="No"
	fi

	if [[ ${MY_P} == "Yes" ]]; then
		let pass++
		eend 0
	else
		let fail++
		eend 1
	fi
	done
}

test_vercmp_no_7() {
	# The following were just tests for != in portage, we need something a bit
	# more precise
	echo "
	1		<	2
	1.0_alpha	<	1.0_pre
	1.0_beta	>	1.0_alpha
	0		<	0.0
	1.0-r0		<	1.0-r1
	1.0-r1		>	1.0-r0
	1.0		<	1.0-r1
	1.0-r1		>	1.0
	1_p1		<	1b_p1
	1b		>	1
	1.1b		>	1.1
	12.2b		>	12.2

	" | while read a b c ; do
	[[ -z "${a}${b}${c}" ]] && continue
	ebegin "Testing \"${a} ${b} ${c}\""

	if vercmp "${a}" "${b}" "${c}"; then
		MY_P="Yes"
	else
		MY_P="No"
	fi

	if [[ ${MY_P} == "Yes" ]]; then
		let pass++
		eend 0
	else
		let fail++
		eend 1
	fi
	done
}

test_vercmp_no_8() {
	# The following tests all come from paludis's test cases:
	echo "
	1.0			>	1
	1			<	1.0
	1.0_alpha		>	1_alpha
	1.0_alpha		>	1
	1.0_alpha		<	1.0
	1.2.0.0_alpha7-r4	>	1.2_alpha7-r4

	" | while read a b c ; do
	[[ -z "${a}${b}${c}" ]] && continue
	ebegin "Testing \"${a} ${b} ${c}\""

	if vercmp "${a}" "${b}" "${c}"; then
		MY_P="Yes"
	else
		MY_P="No"
	fi

	if [[ ${MY_P} == "Yes" ]]; then
		let pass++
		eend 0
	else
		let fail++
		eend 1
	fi
	done
}

test_vercmp_no_9() {
	echo "
	0001	=	1
	01	=	001
	0001.1	=	1.1
	01.01	=	1.01
	1.010	=	1.01
	1.00	=	1.0
	1.0100	=	1.010
	1	=	1-r0
	1-r00	=	1-r0

	" | while read a b c ; do
	[[ -z "${a}${b}${c}" ]] && continue
	ebegin "Testing \"${a} ${b} ${c}\""

	if vercmp "${a}" "${b}" "${c}"; then
		MY_P="Yes"
	else
		MY_P="No"
	fi

	if [[ ${MY_P} == "Yes" ]]; then
		let pass++
		eend 0
	else
		let fail++
		eend 1
	fi
	done
}

PASSING=0
FAILING=0

ebegin "Unit testing geek-solver.eclass"
	eindent
	etest test_vercmp_no_1
	etest test_vercmp_no_2
	etest test_vercmp_no_3
	etest test_vercmp_no_4
	etest test_vercmp_no_5
	etest test_vercmp_no_6
	etest test_vercmp_no_7
	etest test_vercmp_no_8
	etest test_vercmp_no_9
	eoutdent
	einfo "TOTAL: ${PASSING} passing, ${FAILING} failing"
	[[ ${FAILING} -eq 0 ]]
eend $?
