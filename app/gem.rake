
namespace :app do
  namespace :gem do

    desc 'reinstall gems from github'
    task :reinstall do
      AppDeploy.gem.each{ |dep| AppDeploy.install_gem(*dep) }
    end

  end # of server
end # of app
