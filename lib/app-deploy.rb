
%w[deploy gem git install merb mongrel nginx server thin].each{ |task|
  load "app-deploy/#{task}.rake"
}

module AppDeploy
  module_function
  def clone opts
    user, proj, path = opts[:github_user], opts[:github_project], opts[:git_path]

    if File.exist?(path)
      puts "Skip #{proj} because #{path} exists"
    else
      sh "git clone git://github.com/#{user}/#{proj}.git #{path}"
      sh "git --git-dir #{path}/.git gc"
    end
  end

  def installed_gem? gem_name
    `gem list '^#{gem_name}$'` =~ /^#{gem_name}/
  end

  def install_gem opts
    gem_name = opts[:gem] || opts[:github_project]

    if AppDeploy.installed_gem?(gem_name)
      puts "Skip #{gem_name} because it was installed. Uninstall first if you want to reinstall"

    else
      if opts[:gem]
        AppDeploy.install_gem_rubyforge(opts[:gem])
      else
        AppDeploy.install_gem_github(opts[:github_project], opts[:task_gem])
      end

    end
  end

  def uninstall_gem opts
    gem_name = opts[:gem] || opts[:github_project]
    if AppDeploy.installed_gem?(gem_name)
      sh "gem uninstall #{gem_name}"
    else
      puts "Skip #{gem_name} because it was not installed"
    end
  end

  def install_gem_rubyforge gem_name
    sh "gem install #{gem_name} --no-ri --no-rdoc"
  end

  def install_gem_github proj, task
    case task
      when 'bones'
        sh 'rake clobber'
        sh 'rake gem:package'
        sh "gem install --local pkg/#{proj}-*.gem --no-ri --no-rdoc"

      when 'hoe'
        sh 'rake gem'
        sh "gem install --local pkg/#{proj}-*.gem --no-ri --no-rdoc"

      when Proc
        task.call
    end
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
    with = [:github, :gem] if with.empty?
    cwd = Dir.pwd

    # github's gem would be in @github and @gem,
    # so call uniq to ensure it wouldn't get called twice.
    with.map{ |kind| AppDeploy.send(kind) }.flatten.uniq.each{ |opts|
      puts

      begin
        if opts[:github_project]
          if File.directory?(opts[:git_path])
            Dir.chdir(opts[:git_path])
          else
            puts "Skip #{opts[:github_project]}, because it was not found"
          end
        end

        yield(opts)

      rescue RuntimeError => e
        puts e

      ensure
        Dir.chdir(cwd)

      end
    }
  end

  def read_pid pid_path
    if File.exist?(pid_path)
      File.read(pid_path).strip.to_i

    else
      puts "WARN: No pid file found in #{pid_path}"
      nil

    end
  end

  def hup pid_path, name = nil
    if pid = AppDeploy.read_pid(pid_path)
      puts "Sending HUP to #{name}(#{pid})..."
      Process.kill('HUP', pid)
    end
  end

  def term pid_path, name = nil, limit = 5
    if pid = AppDeploy.read_pid(pid_path)
      puts "Sending TERM to #{name}(#{pid})..."

    else
      return

    end

    require 'timeout'
    begin
      timeout(limit){
        while true
          Process.kill('TERM', pid)
          sleep(0.1)
        end
      }
    rescue Errno::ESRCH
      puts "Killed #{name}(#{pid})"

    rescue Timeout::Error
      puts "Timeout(#{limit}) killing #{name}(#{pid})"

    end
  end

end
