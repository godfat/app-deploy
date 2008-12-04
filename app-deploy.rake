
Dir["#{File.dirname(__FILE__)}/app/*.rake"].each{ |rake|
  load rake
}

namespace :app do
  desc 'deploy to master state'
  task :deploy => 'deploy:default'

  desc 'install this application'
  task :install => 'install:default'
end

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

  def clone_gem opts
    clone(opts)
    install_gem(opts)
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
      Dir.chdir opts[:git_path]

      begin
        yield(opts)
      ensure
        Dir.chdir cwd
      end
    }
  end

end
