#!/bin/sh

git fetch
git stash
git checkout origin/stable
git submodule update
./bin/start.sh
