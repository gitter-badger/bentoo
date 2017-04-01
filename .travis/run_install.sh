#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/travis-functions.sh" || exit 1

install_portage() {
    announce pip --verbose install 'lxml>=3.6,<3.7'
    announce .travis/install_portage.sh
}

if [[ ${SHELLCHECK} == 1 ]] ; then
    :
else
    install_portage
fi
