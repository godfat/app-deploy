
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
    task :remote, :host, :git, :cd do |t, args|
      unless [args[:host], args[:git], args[:cd]].all?
        puts 'please fill your arguments like:'
        puts "  > rake app:install:remote[#{args.names.join(',').upcase}]"
        exit(1)
      end
      tmp = "app-deploy-#{Time.now.to_i}"

      chdir = "cd #{args[:cd]}"
      clone = "git clone #{args[:git]} #{tmp}"
      setup = "find #{tmp} -maxdepth 1 '!' -name #{tmp} -exec mv '{}' . ';'"
      rmdir = "rmdir #{tmp}"

      sh "ssh #{args[:host]} \"#{chdir}; #{clone}; #{setup}; #{rmdir}\""
    end

  end # of install
end # of app
