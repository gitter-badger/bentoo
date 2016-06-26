#!/bin/sh

dirname="/opt/spflashtool"
exe="flash_tool"
export LD_LIBRARY_PATH="$dirname"

"$dirname/$exe" "$@"

