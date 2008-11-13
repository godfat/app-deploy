
namespace :app do
  namespace :gem do

    desc 'reinstall gems from github'
    task :reinstall do
      AppDeploy.gem.each{ |opts| AppDeploy.install_gem(opts) }
    end

  end # of server
end # of app
