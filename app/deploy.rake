
namespace :app do
  namespace :deploy do
    desc 'before deploy hook for you to override'
    task :before

    desc 'after deploy hook for you to override'
    task :after

    task :default => [:before, 'git:reset',
                               'git:pull',
                               'gem:reinstall',
                               'server:restart', :after]

  end # of deploy
end # of app
