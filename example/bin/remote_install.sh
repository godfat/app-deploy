#!/bin/sh

rake app:install:remote:setup user=cas file=ssh.tgz hosts=root@10.0.0.101,root@10.0.0.106,root@10.0.0.111,root@10.0.0.116,root@10.0.0.121

rake app:install:remote hosts=cas@10.0.0.101,cas@10.0.0.106,cas@10.0.0.111,cas@10.0.0.116,cas@10.0.0.121 \
                          git=git@github.com:godfat/cas.git \
                           cd=~ \
                       branch=origin/stable \
                       script=./install.sh
