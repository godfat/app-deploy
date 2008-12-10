
namespace :app do
  namespace :thin do

    [:start, :stop, :restart].each{ |name|
      desc "#{name} the thin cluster"
      task name, :config do |t, args|
        sh "thin -C #{args[:config] || 'config/thin.yml'} #{name}"
      end
    }

  end # of thin
end # of app
