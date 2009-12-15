
namespace :app do
  namespace :signal do

    desc 'execute a script if pidfile is not existed'
    task :start, [:script, :pidfile] do |t, args|
      if File.exist?(args[:pidfile])
        puts "WARN: pid file #{args[:pidfile]} already exists, ignoring."
      else
        sh args[:script]
      end
    end

    desc 'terminate a process with a pidfile'
    task :stop, [:pidfile, :timeout, :name] do |t, args|
      # sh "kill -TERM `cat tmp/pids/nginx.pid`"
      AppDeploy.term(args[:pidfile], args[:name], args[:timeout] || 5)
    end

    desc 'restart a process with a pidfile'
    task :restart, [:script, :pidfile, :timeout, :name] => [:stop, :start]

    desc 'send HUP to a process with a pidfile'
    task :reload, [:pidfile, :name] do
      # sh 'kill -HUP `cat tmp/pids/nginx.pid`'
      AppDeploy.kill_pidfile('HUP', args[:pidfile], args[:name])
    end

    desc 'send a signal to a process with a pidfile'
    task :kill, [:signal, :pidfile, :name] do |t, args|
      AppDeploy.kill_pidfile(args[:signal], args[:pidfile], args[:name])
    end

  end # of signal
end # of app
