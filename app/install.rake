
namespace :app do
  namespace :install do
    desc 'before install hook for you to override'
    task :before

    desc 'after install hook for you to override'
    task :after

    task :default => [:before, :do_install, :after]

    task :do_install do
      AppDeploy.dep.each{ |dep| AppDeploy.install(    *dep) }
      AppDeploy.gem.each{ |dep| AppDeploy.install_gem(*dep) }
    end

  end # of install
end # of app
