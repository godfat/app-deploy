
%w[ deploy gem git install merb mongrel
    nginx server thin rack daemon].each{ |task|
  load "app-deploy/#{task}.rake"
}

require 'app-deploy/utils'
