#!/usr/bin/gawk -f
# Copyright 2016 Jan Chren (rindeal) <dev.rindeal@gmail.com>
# Distributed under the terms of the GNU General Public License v2

# travis-ci supports only basic colours
function bold(s)    { return "\033[1m" s "\033[0m" }

function black(s)   { return "\033[30m" s "\033[0m" }
function red(s)     { return "\033[31m" s "\033[0m" }
function green(s)   { return "\033[32m" s "\033[0m" }
function yellow(s)  { return "\033[33m" s "\033[0m" }
function blue(s)    { return "\033[34m" s "\033[0m" }
function magenta(s) { return "\033[35m" s "\033[0m" }
function cyan(s)    { return "\033[36m" s "\033[0m" }
function light_grey(s)  { return "\033[37m" s "\033[0m" }
function white(s)   { return "\033[97m" s "\033[0m" }

function bg_black(s)    { return "\033[40m" s "\033[0m" }
function bg_red(s)      { return "\033[41m" s "\033[0m" }
function bg_green(s)    { return "\033[42m" s "\033[0m" }
function bg_yellow(s)   { return "\033[43m" s "\033[0m" }
function bg_blue(s)     { return "\033[44m" s "\033[0m" }
function bg_magenta(s)  { return "\033[45m" s "\033[0m" }
function bg_cyan(s)     { return "\033[46m" s "\033[0m" }
function bg_light_grey(s)   { return "\033[47m" s "\033[0m" }
function bg_white(s)    { return "\033[107m" s "\033[0m" }

BEGIN {
    # pkgs = []
    other = ""
}

# 3rd line is the first one not printed before any checks start
NR == 3 {
    printf("\n")
    printf(yellow(bold( "Repoman results")) "\n")
    printf(green(bold(  "---------------")) "\n")
    printf("\n")
}

NR < 4 { next }
/NumberOf/{ next }
# any empty line after it marks the end of the useful output
length($0) < 2 { exit 0 }

{
    ok = match($0, /^([a-zA-Z.]+) *([^\/]+\/[^\/]+)\/([^:]+): (.+)/, m)
    errcode = m[1]
    pkg = m[2]
    ebuild = m[3]
    errmsg = m[4]
    if (ok) {
        pkgs[pkg] = sprintf("%s  %s in %s\n    %s\n", pkgs[pkg], cyan(errcode), blue(ebuild), white(bold(errmsg)))
    } else {
        ok = match($0, /^([a-zA-Z.]+) (.+)/, m)
        errcode = m[1]
        errmsg = m[2]
        if (!ok) {
            errcode = "unknown"
            errmsg = $0
        }
        other = sprintf("%s  %s %s\n", other, cyan(errcode), white(bold(errmsg)))
    }
}

END {
    n = asorti(pkgs, sorted)
    for (i = 1; i <= n; i++) {
        pkg = sorted[i]
        printf("%s:\n%s", yellow(bg_black(pkg)), pkgs[pkg])
    }
    if (other)
        printf("\n" yellow(bg_black("Other errors")) ":\n%s\n", other)
}
