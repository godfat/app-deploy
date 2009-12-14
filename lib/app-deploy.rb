
%w[ deploy gem git install nginx server rack daemon signal].each{ |task|
  load "app-deploy/#{task}.rake"
}

require 'app-deploy/utils'
