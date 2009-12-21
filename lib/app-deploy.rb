
require 'app-deploy/utils'

%w[ deploy gem git install remote server
    rack daemon signal nginx unicorn].each{ |task|
  load "app-deploy/#{task}.rake"
}
