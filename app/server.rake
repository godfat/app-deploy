
namespace :app do
  namespace :server do

    desc 'override it if you don\'t use thin'
    task :restart => 'thin:restart'

  end # of server
end # of app
