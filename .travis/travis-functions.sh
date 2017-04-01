#!/bin/bash -e
# https://github.com/travis-ci/travis-rubies

announce() {
  echo \$ "$@"
  "$@"
}

travis_retry() {
  local result=0 count=3
  while ((count--)) ; do
    "$@"
    result=$?

    if [ $result -eq 0 ] ; then
        break
    else
      echo -e "\n\033[33;1mThe command \"$@\" failed. Retrying, $count of 3.\033[0m\n" >&2
    fi

    sleep 1
  done

  [ $count -le 0 ] && {
    echo "\n\033[33;1mThe command \"$@\" failed 3 times.\033[0m\n" >&2
  }

  return $result
}

# Usage: fold_start <TAG> <COMMENT>
#
# These statements can be nested and must be in pair with `fold_end()`.
fold_start() {
  echo -e "travis_fold:start:${1}\033[33;1m${2}\033[0m"
}

# Usage: fold_end <TAG>
fold_end() {
  echo -e "\ntravis_fold:end:${1}\r"
}
