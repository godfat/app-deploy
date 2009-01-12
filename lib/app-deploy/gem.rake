
namespace :app do
  namespace :gem do

    desc 'install gems'
    task :install do
      AppDeploy.gem.each{ |dep|
        puts "installing #{dep[:github_project]}..."
        AppDeploy.install_gem(dep)
      }
    end

  end # of server
end # of app
