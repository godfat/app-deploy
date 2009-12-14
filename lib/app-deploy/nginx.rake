
namespace :app do
  namespace :nginx do

    desc 'start nginx, default config is config/nginx.conf, nginx is /usr/sbin/nginx'
    task :start, [:config, :nginx] do |t, args|
      # TODO: extract pid file path
      if File.exist?('tmp/pids/nginx.pid')
        puts "WARN: pid file #{'tmp/pids/nginx.pid'} already exists, ignoring."
      else
        sh "#{args[:nginx] || '/usr/sbin/nginx'} -c #{args[:config] || 'config/nginx.conf'}"
      end
    end

    desc 'reload config'
    task :reload do
      # sh 'kill -HUP `cat tmp/pids/nginx.pid`'
      AppDeploy.kill_pidfile('HUP', 'tmp/pids/nginx.pid', 'nginx')
    end

    desc 'stop nginx'
    task :stop, [:timeout] do |t, args|
      # sh "kill -TERM `cat tmp/pids/nginx.pid`"
      AppDeploy.term('tmp/pids/nginx.pid', 'nginx', args[:timeout] || 5)
    end

    desc 'restart nginx'
    task :restart => [:stop, :start]

  end # of nginx
end # of app
