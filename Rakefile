
load 'app-deploy.rake'

AppDeploy.dependency_gem 'godfat', 'thumbo',           'tmp/thumbo'
AppDeploy.dependency_gem 'godfat', 'friendly_format',  'tmp/friendly_format'
AppDeploy.dependency     'godfat', 'in_place_editing', 'tmp/in_place_editing'
AppDeploy.dependency     'godfat', 'app-deploy',       'tmp/app-deploy'

namespace :app do
  namespace :install do
    task :before do
      sh 'gem install bones'
    end

  end
end
