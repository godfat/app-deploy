
require 'rubygems'

begin
  require 'app-deploy'

rescue LoadError

  puts "app-deploy not found, automaticly downloading and installing..."

  `git clone git://github.com/godfat/app-deploy.git tmp/app-deploy`
  Dir.chdir 'tmp/app-deploy'

  sh 'rake clobber'
  sh 'rake gem:package'
  sh 'gem install --local pkg/app-deploy-*.gem --no-ri --no-rdoc'

  puts "Please re-invoke: rake #{ARGV.join(' ')}"
  exit(1)

end

task :default do
  Rake.application.options.show_task_pattern = /./
  Rake.application.display_tasks_and_comments
end

# install gem from rubyforge
AppDeploy.dependency_gem :gem            => 'hoe'

# install gem from github with callback
AppDeploy.dependency_gem :github_user    => 'godfat',
                         :github_project => 'app-deploy',
                         :git_path       => 'tmp/app-deploy' do
  sh 'rake clobber'
  sh 'rake gem:package'
  sh 'gem install --local pkg/app-deploy-*.gem --no-ri --no-rdoc'
end

# use bones way same sa above
AppDeploy.dependency_gem :github_user    => 'godfat',
                         :github_project => 'friendly_format',
                         :task_gem       => 'bones',
                         :git_path       => 'tmp/friendly_format'

# use hoe way
AppDeploy.dependency_gem :github_user    => 'godfat',
                         :github_project => 'mogilefs-client',
                         :task_gem       => 'hoe',
                         :git_path       => 'tmp/mogilefs-client'

# no gem to install, just clone it
AppDeploy.dependency     :github_user    => 'godfat',
                         :github_project => 'in_place_editing',
                         :git_path       => 'tmp/vendor/plugins/in_place_editing'

namespace :app do
  namespace :install do
    # before install hook
    task :before do
      # explicit install gem
      AppDeploy.install_gem(:gem => 'bones')
    end

    # after install hook
    task :after do
      # explicit uninstall gem
      AppDeploy.uninstall_gem(:gem => 'bones')
    end
  end

  namespace :server do
    task :restart => 'thin:restart'
  end
end
