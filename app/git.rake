
namespace :app do
  namespace :git do

    desc 'make anything reflect master state'
    task :reset do
      AppDeploy.each{ |opts|
        puts "resetting #{opts[:github_project]}..."
        sh 'git stash' # oops, save your work first.
        sh 'git reset --hard'
      }

      sh 'git stash' # oops, save your work first.
      sh 'git reset --hard'
    end

    desc 'pull anything from origin'
    task :pull do
      AppDeploy.each{ |opts|
        puts "pulling #{opts[:github_project]}..."
        sh 'git pull'
      }
      sh 'git pull' if `git remote` != ''
    end

    desc 'git gc'
    task :gc do
      AppDeploy.each{ |opts|
        puts "garbage collecting #{opts[:github_project]}..."
        sh 'git gc'
      }
      sh 'git gc'
    end

  end # of git
end # of app
