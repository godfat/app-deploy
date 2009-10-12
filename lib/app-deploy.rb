
%w[ deploy gem git install nginx server rack daemon].each{ |task|
  load "app-deploy/#{task}.rake"
}

require 'app-deploy/utils'
