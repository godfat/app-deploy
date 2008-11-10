
namespace :app do
  namespace :thin do

    [:start, :stop, :restart].each{ |name|
      desc "#{name} the thin cluster"
      task name do
        sh "thin -C config/thin.yml #{name}"
      end
    }

  end # of thin
end # of app
