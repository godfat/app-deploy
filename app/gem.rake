
namespace :app do
  namespace :gem do

    desc 'install gems from github'
    task :install do
      AppDeploy.gem.each{ |opts| AppDeploy.install_gem(opts) }
    end

  end # of server
end # of app
