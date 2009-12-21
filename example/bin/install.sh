#!/bin/sh

gem install rake
rake app:install
./bin/start.sh
