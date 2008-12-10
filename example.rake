
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

# install gem callback
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

AppDeploy.dependency     :github_user    => 'godfat',
                         :github_project => 'in_place_editing',
                         :git_path       => 'tmp/vendor/plugins/in_place_editing'

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
