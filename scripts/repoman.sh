#!/bin/bash

repoman full --verbose --output-style column "$@" | "$( dirname "${BASH_SOURCE[0]}" )"/repoman_format.awk
