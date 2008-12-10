
namespace :app do
  namespace :git do

    desc 'make anything reflect master state'
    task :reset do
      puts 'resetting...'
      sh 'git stash' # oops, save your work first.
      sh 'git reset --hard'

      AppDeploy.each{ |opts|
        puts "resetting #{opts[:github_project]}..."
        sh 'git stash' # oops, save your work first.
        sh 'git reset --hard'
      }
    end

    desc 'clone repoitory from github'
    task :clone do
      AppDeploy.dep.each{ |dep|
        puts "cloning #{dep[:github_project]}..."
        AppDeploy.clone(dep)
      }

      AppDeploy.gem.each{ |dep|
        puts "cloning #{dep[:github_project]}..."
        AppDeploy.clone(dep)
      }
    end

    desc 'pull anything from origin'
    task :pull do
      puts 'pulling...'
      begin
        sh 'git pull' if `git remote` =~ /^origin$/
      rescue RuntimeError => e
        puts e
      end

      AppDeploy.each{ |opts|
        puts "pulling #{opts[:github_project]}..."
        sh 'git pull'
      }
    end

    desc 'git gc'
    task :gc do
      puts 'garbage collecting...'
      sh 'git gc'

      AppDeploy.each{ |opts|
        puts "garbage collecting #{opts[:github_project]}..."
        sh 'git gc'
      }
    end

  end # of git
end # of app
