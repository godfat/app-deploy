
namespace :app do
  namespace :merb do

    desc 'start the merb server, default config: config/merb.yml'
    task :start, [:config] do |t, args|
      sh "merb #{AppDeploy.extract_config(args[:config] || 'config/merb.yml')}"
    end

    desc 'stop the merb server'
    task :stop do
      sh 'merb -K all'
      sleep(0.5)
    end

    desc 'restart the merb server'
    task :restart => [:stop, :start]

  end # of merb
end # of app
