
load 'app-deploy.rake'

# install gem callback
AppDeploy.dependency_gem :github_user    => 'godfat',
                         :github_project => 'thumbo',
                         :git_path       => 'tmp/thubmo' do
  sh 'rake clobber'
  sh 'rake gem:package'
  sh 'gem install --local pkg/thumbo-*.gem --no-ri --no-rdoc'
end

# use bones way same sa above
AppDeploy.dependency_gem :github_user    => 'godfat',
                         :github_project => 'friendly_format',
                         :task_gem       => 'bones',
                         :git_path       => 'tmp/friendly_format'

AppDeploy.dependency     :github_user    => 'godfat',
                         :github_project => 'app-deploy',
                         :git_path       => 'tmp/app-deploy'

namespace :app do
  namespace :install do
    task :before do
      sh 'gem install bones --no-ri --no-rdoc' if `gem which bones` =~ /Can't find/
    end
  end

  namespace :server do
    task :restart => 'thin:restart'
  end
end
