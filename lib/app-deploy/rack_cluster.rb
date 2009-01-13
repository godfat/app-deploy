
module RackCluster
  module_function
  def each path
    config_orig = {}
    rack_opts = AppDeploy.extract_config(path){ |opt, value|
      case opt
        when 'environment'
          "--env #{value}"

        when *%w[server host]
          config_orig[opt.to_sym] = value
          "--#{opt} #{value}"

        when *%w[user group chdir servers require rackup daemonize port pid log]
          config_orig[opt.to_sym] = value
          nil # rack doesn't have this option

        else
          "--#{opt} #{value}"

      end
    }

    args = [:pid, :log, :user, :group, :chdir].map{ |kind|
      config_orig.send(:[], kind)
    }.join("', '")

    init_script = "RackDaemon.daemonize('#{args}')"
    ruby_opts   = "-r rubygems -r app-deploy/rack_daemon -e \"#{init_script}\""

    config_orig[:servers].times{ |n|
      config = config_orig.dup

      config[:port] += n
      config[:pid] = RackCluster.pid_path(config[:pid], config[:port])
      config[:log] = RackCluster.log_path(config[:log], config[:port])

      yield( config, ruby_opts,
             rack_opts + " --port #{config[:port]} --pid #{config[:pid]}" )
    }

  end

  def start config, ruby_opts, rack_opts
    puts "Starting #{config[:server]} on #{config[:host]}:#{config[:port]}..."
    sh "rackup #{ruby_opts} #{rack_opts} #{config[:rackup]}"
  end

  def pid_path path, port
    RackCluster.include_server_number(path, port)
  end

  def log_path path, port
    File.expand_path(RackCluster.include_server_number(path, port))
  end

  # extracted from thin
  # Add the server port or number in the filename
  # so each instance get its own file
  def include_server_number path, number
    ext = File.extname(path)
    path.gsub(/#{ext}$/, ".#{number}#{ext}")
  end

end
