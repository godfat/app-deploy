
namespace :app do
  namespace :mongrel do

    [:start, :stop, :restart].each{ |name|
      desc "#{name} the mongrel cluster"
      task name do
        sh "mongrel_rails cluster::#{name}"
      end
    }

  end # of mongrel
end # of app
