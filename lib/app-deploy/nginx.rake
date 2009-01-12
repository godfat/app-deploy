
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
      # sh 'kill -HUP `cat tmp/pids/nginx.pid`'
      Process.kill('HUP', File.read('tmp/pids/nginx.pid').strip.to_i)
    end

    desc 'stop nginx'
    task :stop do
      # sh "kill -TERM `cat tmp/pids/nginx.pid`"
      Process.kill('TERM', File.read('tmp/pids/nginx.pid').strip.to_i)
    end

  end # of nginx
end # of app
