#!/bin/bash

git config user.name "Travis CI"
git config user.email "Travis@CI"
git reset --hard ${TRAVIS_COMMIT}
