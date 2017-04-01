#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/travis-functions.sh" || exit 1

run_repoman() {
    echo "\$ repoman full"
    "$(dirname "${BASH_SOURCE[0]}")/../scripts/repoman.sh" --xmlparse --without-mask
}

run_shellcheck() {
    local sc_exclude=(
        SC1007  # Remove space after = if trying to assign a value (for empty string, use var='' ... ).
        SC2016  # expressions don't expand in single quotes
        SC2034  # unused vars
        SC2046  # quote to prevent word splitting
        SC2086  # double quote
        SC2128  # Expanding an array without an index only gives the first element.
    )
    local sc_opts=(
        --shell=bash
        "${sc_exclude[@]/#/--exclude=}"
    )

    # run in a subshell to prevent shopt from leaking
    (
    shopt -s globstar
    echo \$ shellcheck "${sc_opts[@]}" "eclass/*.eclass" "./**/*.ebuild" "./.travis/*.sh"
    shellcheck "${sc_opts[@]}" eclass/*.eclass ./**/*.ebuild ./.travis/*.sh
    )
}

if [[ ${SHELLCHECK} == 1 ]] ; then
    run_shellcheck
else
    run_repoman
fi
