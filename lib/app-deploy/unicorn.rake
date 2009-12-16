
namespace :app do
  namespace :unicorn do

    desc 'start unicorn, default config is config/unicorn.rb'
    task :start, [:config, :env, :unicorn] do |t, args|
      ENV[:script]  =     "#{args[:unicorn] || 'unicorn'}"           +
                      " -c #{args[:config]  || 'config/unicorn.rb'}" +
                      " -E #{args[:env]     || 'production'}"
      ENV[:pidfile] = 'tmp/pids/unicorn.pid'
      Rake::Task['app:signal:start'].invoke
    end

    desc 'stop unicorn'
    task :stop, [:timeout] do |t, args|
      # sh "kill -TERM `cat tmp/pids/unicorn.pid`"
      ENV['pidfile'] = 'tmp/pids/unicorn.pid'
      ENV['timeout'] = args[:timeout]
      ENV['name']    = 'unicorn'
      Rake::Task['app:signal:stop'].invoke
    end

    desc 'restart unicorn'
    task :restart, [:config, :env, :unicorn, :timeout] => [:stop, :start]

    desc 'reload config'
    task :reload do
      # sh 'kill -HUP `cat tmp/pids/unicorn.pid`'
      ENV['signal'] = 'HUP'
      Rake::Task['app:unicorn:kill'].invoke
    end

    desc 'send a signal to unicorn'
    task :kill, [:signal] do |t, args|
      ENV['signal']  = args[:signal]
      ENV['pidfile'] = 'tmp/pids/unicorn.pid'
      ENV['name']    = 'unicorn'
      Rake::Task['app:signal:kill'].invoke
    end

  end # of unicorn
end # of app
