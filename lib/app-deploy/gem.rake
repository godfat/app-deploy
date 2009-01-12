
namespace :app do
  namespace :gem do

    desc 'install gems'
    task :install do
      AppDeploy.each(:gem){ |dep|
        puts "Installing #{dep[:gem] || dep[:github_project]}..."
        AppDeploy.install_gem(dep)
      }
    end

    desc 'uninstall gems'
    task :uninstall do
      AppDeploy.each(:gem){ |dep|
        puts "Uninstalling #{dep[:gem] || dep[:github_project]}..."
        AppDeploy.uninstall_gem(dep)
      }
    end

    desc 'reinstall gems'
    task :reinstall => [:uninstall, :install]

  end # of server
end # of app
