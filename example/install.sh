#!/bin/sh

rake app:install:remote[app-deploy@10.0.0.99,git://github.com/godfat/app-deploy.git,~,origin/stable]
