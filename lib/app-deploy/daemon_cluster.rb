
module AppDeploy

  module DaemonCluster
    module_function
    def each path, ruby
      config_orig = YAML.load(path).inject({}){ |h, kv|
        k,v = kv
        h[k.to_sym] = v
        h
      }

      config_orig = { :servers => 1,
                      :log     => 'log/daemon_cluster.log',
                      :pid     => 'tmp/pids/daemon_cluster.pid'
                    }.merge(config_orig)

      config_orig[:servers].times{ |n|
        config = config_orig.dup

        config[:pid] = DaemonCluster.pid_path(config[:pid], config[:script], n)
        config[:log] = DaemonCluster.log_path(config[:log], config[:script], n)

        args = [:pid, :log, :user, :group, :chdir].map{ |kind|
          value = config.send(:[], kind)
          value ? "'#{value}'" : 'nil'
        }.join(', ')

        init_script = "AppDeploy::Daemon.daemonize(#{args})"
        ruby_opts   = "-r rubygems -r app-deploy/daemon -e \"#{init_script}\""

        yield( config, "#{config[:ruby]} #{ruby_opts} #{config[:script]}" )
      }
    end

    def start config, cmd
      puts "Starting #{config[:ruby]} #{config[:script]}..."
      sh cmd
    end

    def pid_path path, script, number
      DaemonCluster.path_with_number(path, script, number)
    end

    def log_path path, script, number
      # log should expand path since daemons' working dir is different
      File.expand_path(DaemonCluster.path_with_number(path, script, number))
    end

    def with_number path, script, number
      name = File.basename(script).gsub(/\s+/, '_')

      ext = File.extname(path)
      path.gsub(/#{ext}$/, ".#{name}.#{number}#{ext}")
    end
  end # of DaemonCluster
end # of AppDeploy
