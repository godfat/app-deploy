
namespace :app do
  namespace :git do

    desc 'make anything reflect master state'
    task :reset do
      sh 'git stash' # oops, save your work first.
      sh 'git reset --hard'
    end

  end # of git
end # of app
