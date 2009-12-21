#!/bin/sh

git fetch
git reset --hard origin/$branch
git submodule update
./bin/start.sh
