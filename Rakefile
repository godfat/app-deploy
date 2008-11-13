
load 'app-deploy.rake'

# install gem callback
AppDeploy.dependency_gem :github_user    => 'godfat',
                         :github_project => 'thumbo' do
  sh 'rake clobber'
  sh 'rake gem:package'
  sh 'gem install --local pkg/thumbo-*.gem --no-ri --no-rdoc'
end

# use bones way same sa above
AppDeploy.dependency_gem :github_user    => 'godfat',
                         :github_project => 'friendly_format',
                         :task_gem       => 'bones'

# use hoe way
AppDeploy.dependency_gem :github_user    => 'godfat',
                         :github_project => 'mogilefs-client',
                         :task_gem       => 'hoe'

AppDeploy.dependency     :github_user    => 'godfat',
                         :github_project => 'in_place_editing',
                         :git_path       => 'vendor/plugins/in_place_editing'

AppDeploy.dependency     :github_user    => 'godfat',
                         :github_project => 'app-deploy',
                         :git_path       => 'lib/tasks/app-deploy'

namespace :app do
  namespace :install do
    task :before do
      sh 'gem install bones'
    end

  end
end
