
namespace :app do
  namespace :nginx do

    desc 'start nginx, default config is config/nginx.conf, nginx is /usr/sbin/nginx'
    task :start, :config, :nginx do |t, args|
      if !File.exist?('tmp/pids/nginx.pid')
        sh "#{args[:nginx] || '/usr/sbin/nginx'} -c #{args[:config] || 'config/nginx.conf'}"
      end
    end

    desc 'reload config'
    task :restart do
      sh 'kill -HUP `cat tmp/pids/nginx.pid`'
    end

    desc 'stop nginx'
    task :stop do
      sh 'kill -QUIT `cat tmp/pids/nginx.pid`'
    end

  end # of nginx
end # of app
