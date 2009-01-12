
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
      pid = File.read('tmp/pids/nginx.pid').strip.to_i
      puts "Sending HUP to nginx(#{pid})..."
      Process.kill('HUP', pid)
    end

    desc 'stop nginx'
    task :stop, :timeout do |t, args|
      # sh "kill -TERM `cat tmp/pids/nginx.pid`"
      pid = File.read('tmp/pids/nginx.pid').strip.to_i
      puts "Sending TERM to nginx(#{pid})..."
      require 'timeout'
      limit = args[:timeout] || 5
      begin
        timeout(limit){
          while true
            Process.kill('TERM', pid)
            sleep(0.1)
          end
        }
      rescue Errno::ESRCH
        puts "Killed nginx(#{pid})"

      rescue Timeout::Error
        puts "Timeout(#{limit}) killing nginx(#{pid})"

      end
    end

  end # of nginx
end # of app
