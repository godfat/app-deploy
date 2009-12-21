#!/bin/sh

# start or restart server with git HEAD
# i.e. it would remove all local modification
rake app:deploy
