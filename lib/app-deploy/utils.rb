
module AppDeploy
  module_function
  # wrap Rake::Task#invoke for named arguments
  def invoke task_name, hash
    task = Rake::Task[task_name]
    args = task.arg_names.map{ |name| hash[name] }
    task.invoke(*args)
  end

  def always_reenable tasks
    tasks.each{ |t| t.enhance{ |tt| tt.reenable } }
  end

  def github; @github ||= []; end
  def dependency opts = {}
    opts = opts.dup
    opts[:git_path] ||= opts[:github_project]
    github << opts.freeze
  end

  def gem; @gem ||= []; end
  def dependency_gem opts = {}, &block
    opts = opts.dup

    if opts[:github_project]
      opts[:git_path] ||= opts[:github_project]
      opts[:task_gem] = block if block_given?
      github << opts.freeze
    end

    gem << opts.freeze
  end

  def each *with
    # yield common gem first, github gem last
    with = [:gem, :github] if with.empty?
    cwd = Dir.pwd

    # github's gem would be in @github and @gem,
    # so call uniq to ensure it wouldn't get called twice.
    with.map{ |kind| AppDeploy.send(kind) }.flatten.uniq.each{ |opts|
      puts

      if opts[:github_project]
        if File.directory?(opts[:git_path])
          begin
            Dir.chdir(opts[:git_path])
            yield(opts)
          rescue RuntimeError => e
            puts e
          ensure
            Dir.chdir(cwd)
          end
        else
          puts "Skip #{opts[:github_project]}, because it was not found"
        end
      else # it's a plain gem
        yield(opts)
      end
    }
  end

  def extract_config config
    require 'yaml'
    YAML.load(File.read(config)).inject([]){ |result, opt_value|
      opt, value = opt_value
      if block_given?
        result << yield(opt, value)
      else
        result << "--#{opt} #{value}"
      end
      result
    }.compact.join(' ')
  end

  # about git
  def clone opts
    user, proj, path = opts[:github_user], opts[:github_project], opts[:git_path]

    if File.exist?(path)
      puts "Skip #{proj} because #{path} exists"
    else
      sh "git clone git://github.com/#{user}/#{proj}.git #{path}"
      sh "git --git-dir #{path}/.git gc"
    end
  end

  # about gem
  def installed_gem? gem_name
    # `#{gem_bin} list '^#{gem_name}$'` =~ /^#{gem_name}/
    Gem.send(:gem, gem_name)
    true
  rescue LoadError
    false
  end

  def install_gem opts
    gem_name = opts[:gem] || opts[:github_project]

    if AppDeploy.installed_gem?(gem_name)
      puts "Skip #{gem_name} because it was installed. Uninstall first if you want to reinstall"

    else
      if opts[:gem]
        AppDeploy.install_gem_remote(opts[:gem], opts[:source])
      else
        AppDeploy.install_gem_local(opts[:github_project], opts[:task_gem])
      end

    end
  end

  def uninstall_gem opts
    gem_name = opts[:gem] || opts[:github_project]
    if AppDeploy.installed_gem?(gem_name)
      sh "#{gem_bin} uninstall #{gem_name}"
    else
      puts "Skip #{gem_name} because it was not installed"
    end
  end

  def install_gem_remote gem_name, source = nil
    sh "#{gem_bin} install #{gem_name}#{source ? ' --source ' + source : ''}"
  end

  def install_gem_local proj, task
    case task
      when 'bones'
        sh 'rake clobber'
        sh 'rake gem:package'
        sh "#{gem_bin} install --local pkg/#{proj}-*.gem --no-ri --no-rdoc"

      when 'hoe'
        sh 'rake gem'
        sh "#{gem_bin} install --local pkg/#{proj}-*.gem --no-ri --no-rdoc"

      when Proc
        task.call
    end
  end

  def gem_bin
    Gem.ruby + ' ' + `which gem`.strip
  end

  # about sending signal
  def read_pid pid_path
    if File.exist?(pid_path)
      File.read(pid_path).strip.to_i

    else
      puts "WARN: No pid file found in #{pid_path}"
      nil

    end
  end

  def term pid_path, name = nil, limit = 5, wait = 0.1
    require 'timeout'
    pid = AppDeploy.kill_pidfile('TERM', pid_path, name)
    Timeout.timeout(limit.to_i){
      if pid
        while true
          Process.kill('TERM', pid)
          sleep(wait)
        end
      end
    }
  rescue Errno::ESRCH
    puts "Killed #{name}(#{pid})"

  rescue Timeout::Error
    puts "Timeout(#{limit}) killing #{name}(#{pid})"

  end

  def kill_pidfile signal, pid_path, name = nil
    if pid = AppDeploy.read_pid(pid_path)
      AppDeploy.kill_raise(signal, pid, name)
      return pid
    end
    nil
  rescue Errno::ESRCH
    puts "WARN: No such pid: #{pid}, removing #{pid_path}..."
    File.delete(pid_path)
    nil
  end

  def kill_pid signal, pid, name = nil
    AppDeploy.kill_raise(signal, pid, name)
    pid
  rescue Errno::ESRCH
    puts "WARN: No such pid: #{pid}"
    nil
  end

  def kill_raise signal, pid, name = nil
    puts "Sending #{signal} to #{name}(#{pid})..."
    Process.kill(signal, pid)
    pid
  end

end
