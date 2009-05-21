
module AppDeploy

  module DaemonCluster
    module_function
    def each path
      config_orig = YAML.load(File.read(path)).inject({}){ |h, kv|
        k, v = kv
        h[k.to_sym] = v
        h
      }

      config_orig = { :servers => 1,
                      :log     => 'log/daemon_cluster.log',
                      :pid     => 'tmp/pids/daemon_cluster.pid'
                    }.merge(config_orig)

      config_orig[:servers].times{ |n|
        config = config_orig.dup

        config[:num] = n
        config[:pid] = DaemonCluster.pid_path(config, n)
        config[:log] = DaemonCluster.log_path(config, n)

        args = [:pid, :log, :user, :group, :chdir].map{ |kind|
          value = config.send(:[], kind)
          value ? "'#{value}'" : 'nil'
        }.join(', ')

        init_script = "require 'app-deploy/daemon'; AppDeploy::Daemon.daemonize(#{args});"
        ruby_opts   = "-r rubygems -e \"#{init_script} load('#{config[:script]}')\""

        yield( config, "#{config[:ruby]} #{ruby_opts} #{config[:args]}" )
      }
    end

    def start config, cmd
      puts "Starting ##{config[:num]} #{config[:ruby]} #{config[:script]} #{config[:args]}..."
      sh cmd
      puts
    end

    def pid_path config, number
      path, script, args = config[:pid], config[:script], config[:args]
      DaemonCluster.path_with_number(path, script, args, number)
    end

    def log_path config, number
      # log should expand path since daemons' working dir is different
      path, script, args = config[:log], config[:script], config[:args]
      File.expand_path(DaemonCluster.path_with_number(path, script, args, number))
    end

    def path_with_number path, script, args, number
      name = (args ? File.basename("#{script} #{args}")
                   : File.basename(script)             ).gsub(/\s+/, '_')

      ext = File.extname(path)
      path.gsub(/#{ext}$/, ".#{name}.#{number}#{ext}")
    end
  end # of DaemonCluster
end # of AppDeploy
