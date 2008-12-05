
namespace :app do
  namespace :merb do

    desc 'start the merb server, default config: config/merb.yml'
    task :start, :config do |t, args|
      require 'yaml'
      merb_opt = YAML.load(File.read(args[:config] || 'config/merb.yml')).
        inject([]){ |result, opt_value|
          opt, value = opt_value
          result << "--#{opt} #{value}"
          result
        }.join(' ')

      sh "merb #{merb_opt}"
    end

    desc 'stop the merb server'
    task :stop do
      sh 'merb -K all'
    end

    desc 'restart the merb server'
    task :restart => [:stop, :start]

  end # of merb
end # of app
