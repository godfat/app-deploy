#!/bin/sh

rake app:install:remote:sh hosts=cas@10.0.0.101,cas@10.0.0.106,cas@10.0.0.111,cas@10.0.0.116,cas@10.0.0.121 script=./update.sh
