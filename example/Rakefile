
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
AppDeploy.dependency_gem :gem => 'bones'

# install gem from github
AppDeploy.dependency_gem :gem => 'pagfiy', :source => 'http://gems.github.com'

# clone and build and install gem from github with bones
AppDeploy.dependency_gem :github_user    => 'godfat',
                         :github_project => 'friendly_format',
                         :task_gem       => 'bones',
                         :git_path       => 'tmp/friendly_format'

# same as above but with hoe
AppDeploy.dependency_gem :github_user    => 'godfat',
                         :github_project => 'mogilefs-client',
                         :task_gem       => 'hoe',
                         :git_path       => 'tmp/mogilefs-client'

# same as above but with custom install script
AppDeploy.dependency_gem :github_user    => 'godfat',
                         :github_project => 'app-deploy',
                         :git_path       => 'tmp/app-deploy' do
  sh 'rake clobber'
  sh 'rake gem:package'
  sh 'gem install --local pkg/app-deploy-*.gem --no-ri --no-rdoc'
end

# no gem to install, just clone it
AppDeploy.dependency     :github_user    => 'godfat',
                         :github_project => 'in_place_editing',
                         :git_path       => 'tmp/vendor/plugins/in_place_editing'

namespace :app do
  namespace :install do
    # before install hook
    task :before do
      # explicit install gem, ignore gem that was already installed
      AppDeploy.install_gem(:gem => 'hoe')
    end

    # after install hook
    task :after do
      # explicit uninstall gem, ignore gem that was not installed
      AppDeploy.uninstall_gem(:gem => 'zzz')
    end
  end

  namespace :server do
    # use thin as server
    task :restart => 'thin:restart'
  end
end
