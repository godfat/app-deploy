
Dir["#{Dir.pwd}/app/*.rake"].each{ |rake|
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
  def install user, proj, path = proj
    if File.exist?(path)
      puts "skip #{proj} because #{path} exists"
    else
      sh "git clone git://github.com/#{user}/#{proj}.git #{path}"
      sh "git --git-dir #{path}/.git gc"
    end
  end

  def install_gem user, proj, path = proj
    install user, proj, path
    cwd = Dir.pwd
    Dir.chdir path
    sh 'rake gem:install'
  ensure
    Dir.chdir cwd
  end

  def dep; @dep ||= []; end
  def dependency user, proj, path = proj
    dep << [user, proj, path]
  end

  def gem; @gem ||= []; end
  def dependency_gem user, proj, path = proj
    gem << [user, proj, path]
  end

  def each
    cwd = Dir.pwd

    (AppDeploy.dep + AppDeploy.gem).each{ |dep|
      Dir.chdir dep.last

      begin
        yield(dep)
      ensure
        Dir.chdir cwd
      end
    }
  end

end
