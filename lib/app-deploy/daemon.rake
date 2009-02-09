
require 'app-deploy/daemon_cluster'

namespace :app do
  namespace :daemon do

    desc 'start the daemon cluster'
    task :start, :config do |t, args|
      path = args[:config] || 'config/daemon_cluster.yaml'
      AppDeploy::DaemonCluster.each(path){ |config, cmd|
        AppDeploy::DaemonCluster.start(config, cmd)
      }
    end

    desc 'stop the daemon cluster'
    task :stop, :config do |t, args|
      path = args[:config] || 'config/daemon_cluster.yaml'
      AppDeploy::DaemonCluster.each(path){ |config, cmd|
        AppDeploy.term(config[:pid], config[:server])
      }
    end

    desc 'restart the daemon cluster'
    task :restart, :config do |t, args|
      path = args[:config] || 'config/daemon_cluster.yaml'
      AppDeploy::DaemonCluster.each(path){ |config, cmd|
        AppDeploy.term(config[:pid], config[:server])
        AppDeploy::DaemonCluster.start(config, cmd)
        puts
      }
    end

  end # of rack
end # of app
