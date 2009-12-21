#!/bin/sh

source .bash_profile

rake app:remote:sh hosts=$hosts script="$1"
