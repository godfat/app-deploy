
namespace :app do

  desc 'install this application'
  task :install => 'install:default'

  namespace :install do
    desc 'before install hook for you to override'
    task :before

    desc 'after install hook for you to override'
    task :after

    task :default => [:before,
                      'git:submodule',
                      'git:clone',
                      'gem:install',
                      :after]

    desc 'remote installation'
    task :remote, [:hosts, :git, :cd, :branch, :script] => 'remote:install'

  end # of install
end # of app
