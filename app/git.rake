
namespace :app do
  namespace :git do

    desc 'make anything reflect master state'
    task :reset do
      sh 'git stash' # oops, save your work first.
      sh 'git reset --hard'
    end

    desc 'pull anything from origin'
    task :pull do
      (AppDeploy.dep + AppDeploy.gem).each{ |dep|
        sh "git --git-dir #{dep.last}/.git pull"
        sh 'git pull' if `git remote` != ''
      }
    end

  end # of git
end # of app
