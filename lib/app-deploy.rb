
%w[deploy gem git install merb mongrel nginx server thin].each{ |task|
  load "app-deploy/#{task}.rake"
}

module AppDeploy
  module_function
  def clone opts
    user, proj, path = opts[:github_user], opts[:github_project], opts[:git_path]

    if File.exist?(path)
      puts "skip #{proj} because #{path} exists"
    else
      sh "git clone git://github.com/#{user}/#{proj}.git #{path}"
      sh "git --git-dir #{path}/.git gc"
    end
  end

  def install_gem opts
    user, proj, path = opts[:github_user], opts[:github_project], opts[:git_path]
    task = opts[:task_gem]

    cwd = Dir.pwd
    Dir.chdir path
    case task
      when 'bones';
        sh 'rake clobber'
        sh 'rake gem:package'
        sh "gem install --local pkg/#{proj}-*.gem --no-ri --no-rdoc"

      when 'hoe';
        sh 'rake gem'
        sh "gem install --local pkg/#{proj}-*.gem --no-ri --no-rdoc"

      when Proc;
        task.call
    end

  ensure
    Dir.chdir cwd
  end

  def dep; @dep ||= []; end
  def dependency opts = {}
    opts = opts.dup
    opts[:git_path] ||= opts[:github_project]

    dep << opts.freeze
  end

  def gem; @gem ||= []; end
  def dependency_gem opts = {}, &block
    opts = opts.dup
    opts[:git_path] ||= opts[:github_project]

    opts[:task_gem] = block if block_given?
    gem << opts.freeze
  end

  def each
    cwd = Dir.pwd

    (AppDeploy.dep + AppDeploy.gem).each{ |opts|
      puts
      if File.directory?(opts[:git_path])
        Dir.chdir opts[:git_path]
      else
        puts "skipping #{opts[:github_project]}, because it was not found."
        next
      end

      begin
        yield(opts)
      rescue RuntimeError => e
        puts e
      ensure
        Dir.chdir cwd
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
