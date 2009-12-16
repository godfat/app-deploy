
namespace :app do
  namespace :nginx do

    desc 'start nginx, default config is config/nginx.conf'
    task :start, [:config, :nginx] do |t, args|
      ENV['script']  = "    #{args[:nginx]  || '/usr/sbin/nginx'}"   +
                       " -c #{args[:config] || 'config/nginx.conf'}"
      ENV['pidfile'] = 'tmp/pids/nginx.pid'
      Rake::Task['app:signal:start'].invoke
    end

    desc 'stop nginx'
    task :stop, [:timeout] do |t, args|
      # sh "kill -TERM `cat tmp/pids/nginx.pid`"
      ENV['pidfile'] = 'tmp/pids/nginx.pid'
      ENV['timeout'] = args[:timeout]
      ENV['name']    = 'nginx'
      Rake::Task['app:signal:stop'].invoke
    end

    desc 'restart nginx'
    task :restart, [:config, :nginx, :timeout] => [:stop, :start]

    desc 'reload config'
    task :reload do
      # sh 'kill -HUP `cat tmp/pids/nginx.pid`'
      ENV['signal'] = 'HUP'
      Rake::Task['app:nginx:kill'].invoke
    end

    desc 'send a signal to nginx'
    task :kill, [:signal] do |t, args|
      ENV['signal']  = args[:signal]
      ENV['pidfile'] = 'tmp/pids/nginx.pid'
      ENV['name']    = 'nginx'
      Rake::Task['app:signal:kill'].invoke
    end

  end # of nginx
end # of app
