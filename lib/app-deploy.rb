
require 'app-deploy/utils'

%w[ deploy gem git install server rack daemon signal nginx unicorn].each{ |task|
  load "app-deploy/#{task}.rake"
}
