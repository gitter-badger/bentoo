#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/travis-functions.sh" || exit 1

PORTAGE_ROOT="$(mktemp -d --suffix=-PORTAGE_ROOT)"
export PORTAGE_ROOT PORTAGE_CONFIGROOT="${PORTAGE_ROOT}" ROOT="${PORTAGE_ROOT}"

# silences crappy warnings
export PORTAGE_GRPNAME='root' PORTAGE_USERNAME='root'

# allow calling portage binaries directly
export PATH="${PORTAGE_ROOT}/usr/bin:${PATH}"
