
namespace :app do
  namespace :nginx do

    desc 'start nginx, default config is config/nginx.conf'
    task :start, [:config, :nginx] do |t, args|
      script =     "#{args[:nginx]  || '/usr/sbin/nginx'}"   +
               " -c #{args[:config] || 'config/nginx.conf'}"
      Rake::Task['app:signal:start'].invoke(script, 'tmp/pids/nginx.pid')
    end

    desc 'stop nginx'
    task :stop, [:timeout] do |t, args|
      # sh "kill -TERM `cat tmp/pids/nginx.pid`"
      Rake::Task['app:signal:stop'].invoke(
        'tmp/pids/nginx.pid', args[:timeout], 'nginx')
    end

    desc 'restart nginx'
    task :restart, [:config, :nginx, :timeout] => [:stop, :start]

    desc 'reload config'
    task :reload do
      # sh 'kill -HUP `cat tmp/pids/nginx.pid`'
      Rake::Task['app:nginx:kill'].invoke('HUP')
    end

    desc 'send a signal to nginx'
    task :kill, [:signal] do |t, args|
      Rake::Task['app:signal:kill'].invoke(
        args[:signal], 'tmp/pids/nginx.pid', 'nginx')
    end

  end # of nginx
end # of app
