
require 'app-deploy/rack_cluster'

namespace :app do
  namespace :rack do

    desc 'start the rack cluster'
    task :start, :config do |t, args|
      path = args[:config] || 'config/rack_cluster.yaml'
      AppDeploy::RackCluster.each(path){ |config, ruby_opts, rack_opts|
        AppDeploy::RackCluster.start(config, ruby_opts, rack_opts)
      }
    end

    desc 'stop the rack cluster'
    task :stop, :config do |t, args|
      path = args[:config] || 'config/rack_cluster.yaml'
      AppDeploy::RackCluster.each(path){ |config, ruby_opts, rack_opts|
        AppDeploy.term(config[:pid], config[:server])
      }
    end

    desc 'restart the rack cluster'
    task :restart, :config do |t, args|
      path = args[:config] || 'config/rack_cluster.yaml'
      AppDeploy::RackCluster.each(path){ |config, ruby_opts, rack_opts|
        AppDeploy.term(config[:pid], config[:server])
        AppDeploy::RackCluster.start(config, ruby_opts, rack_opts)
        puts
      }
    end

  end # of rack
end # of app
