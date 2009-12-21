#!/bin/sh

source .bash_profile

rake app:remote:useradd user=$project hosts=$nodes

rake app:remote:install hosts=$nodes \
                          git=git@github.com:godfat/$project.git \
                           cd=/home/$project \
                       branch=origin/$branch \
                       script="git submodule init; git submodule update; gem install rake; ./roodo-rc/install.rb; chown $project:$project -R ."

rake app:remote:sh hosts=$hosts script='./bin/install.sh'
