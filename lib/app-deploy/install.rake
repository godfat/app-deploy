
namespace :app do

  desc 'install this application'
  task :install => 'install:default'

  namespace :install do
    desc 'before install hook for you to override'
    task :before

    desc 'after install hook for you to override'
    task :after

    task :default => [:before,
                      'git:submodule',
                      'git:clone',
                      'gem:install',
                      :after]

    desc 'remote installation'
    task :remote, :host, :git, :cd, :branch, :script do |t, args|
      unless [args[:host], args[:git]].all?
        puts 'please fill your arguments like:'
        puts "  > rake app:install:remote[#{args.names.join(',').upcase}]"
        exit(1)
      end

      cd     = args[:cd]     || '~'
      branch = args[:branch] || 'master'
      tmp    = "app-deploy-#{Time.now.to_i}"

      chdir = "cd #{cd}"
      clone = "git clone #{args[:git]} #{tmp}"
      setup = "find #{tmp} -maxdepth 1 '!' -name #{tmp} -exec mv '{}' . ';'"
      rmdir = "rmdir #{tmp}"
      check = "git checkout #{branch}"

      sh "ssh #{args[:host]} \"#{chdir}; #{clone}; #{setup}; #{rmdir}; #{check}; #{args[:script]}\""
    end

    desc 'upload a file to remote machines'
    task :upload, :file, :hosts, :path do |t, args|
      args[:hosts].split(',').each{ |host|
        sh "scp #{args[:file]} #{host}:#{args[:path]}"
      }
    end

    desc 'create a user on remote machines'
    task :init, :user, :hosts, :script do |t, args|
      useradd = "sudo useradd -m #{args[:user]}"
      args[:hosts].split(',').each{ |host|
        sh "ssh #{host} \"#{useradd}; #{args[:script]}\""
      }
    end

    desc 'task init + upload ssh keys and untar it for the user'
    task :setup, :user, :file, :hosts, :script do |t, args|
      ENV['path'] = "/tmp/app-deploy-#{Time.now.to_i}"
      Rake::Task['app:install:upload'].invoke

      ENV['script'] = "sudo -u #{args[:user]} tar -zxf #{ENV['path']}" +
                          " -C /home/#{args[:user]};" +
                      " rm #{ENV['path']}; #{args[:script]}"
      Rake::Task['app:install:init'].invoke
    end

  end # of install
end # of app
