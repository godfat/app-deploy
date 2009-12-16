
ns = namespace :app do
  namespace :unicorn do

    desc 'start unicorn, default config is config/unicorn.rb'
    task :start, [:config, :env, :unicorn] do |t, args|
      script =     "#{args[:unicorn] || 'unicorn'} -D"        +
               " -c #{args[:config]  || 'config/unicorn.rb'}" +
               " -E #{args[:env]     || 'production'}"
      Rake::Task['app:signal:start'].invoke(script, 'tmp/pids/unicorn.pid')
    end

    desc 'stop unicorn'
    task :stop, [:timeout] do |t, args|
      # sh "kill -TERM `cat tmp/pids/unicorn.pid`"
      Rake::Task['app:signal:stop'].invoke(
        'tmp/pids/unicorn.pid', args[:timeout], 'unicorn')
    end

    desc 'restart unicorn'
    task :restart, [:config, :env, :unicorn, :timeout] => [:stop, :start]

    desc 'reload config'
    task :reload do
      # sh 'kill -HUP `cat tmp/pids/unicorn.pid`'
      Rake::Task['app:unicorn:kill'].invoke('HUP')
    end

    desc 'send a signal to unicorn'
    task :kill, [:signal] do |t, args|
      Rake::Task['app:signal:kill'].invoke(
        args[:signal], 'tmp/pids/unicorn.pid', 'unicorn')
    end

  end # of unicorn
end # of app

AppDeploy.always_reenable(ns.tasks)
