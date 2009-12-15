
namespace :app do
  namespace :signal do

    desc 'execute a script if pid file is not existed'
    task :start, [:script, :pidfile] do |t, args|
      if File.exist?(args[:pidfile])
        puts "WARN: pid file #{args[:pidfile]} already exists, ignoring."
      else
        sh args[:script]
      end
    end

    desc 'terminate a process with a pid file'
    task :stop, [:pidfile, :timeout, :name] do |t, args|
      # sh "kill -TERM `cat tmp/pids/nginx.pid`"
      AppDeploy.term(args[:pidfile], args[:name], args[:timeout] || 5)
    end

    desc 'restart a process with a pidfile'
    task :restart, [:script, :pidfile, :timeout, :name] => [:stop, :start]

    desc 'send a signal to a process with a pid file'
    task :kill, [:signal, :pidfile, :name] do |t, args|
      # sh 'kill -HUP `cat tmp/pids/nginx.pid`'
      AppDeploy.kill_pidfile(args[:signal], args[:pidfile], args[:name])
    end

  end # of nginx
end # of app
