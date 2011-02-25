
require "#{dir = File.dirname(__FILE__)}/task/gemgem"
Gemgem.dir = dir

($LOAD_PATH << File.expand_path("#{Gemgem.dir}/lib" )).uniq!

desc 'Generate gemspec'
task 'gem:spec' do
  Gemgem.spec = Gem::Specification.new do |s|
    require 'app-deploy/version'

    s.name    = 'app-deploy'
    s.version = AppDeploy::VERSION

    # s.add_dependency('ripl')
    %w[].each{ |g|
      s.add_development_dependency(g)
    }

    s.authors     = ['Lin Jen-Shin (godfat)']
    s.email       = ['godfat (XD) godfat.org']
    s.homepage    = "http://github.com/godfat/#{s.name}"
    s.summary     = File.read("#{Gemgem.dir}/README").
                    match(/== DESCRIPTION:\n\n(.+)?\n\n== FEATURES:/m)[1]
    s.description = s.summary
    # s.executables = [s.name]

    s.date             = Time.now.strftime('%Y-%m-%d')
    s.rubygems_version = Gem::VERSION
    s.files            = Gemgem.gem_files
    s.test_files       = Gemgem.gem_files.grep(/test_.+?\.rb$/)
    s.extra_rdoc_files = %w[CHANGES TODO]
    s.rdoc_options     = %w[--main README]
    s.require_paths    = %w[lib]
  end

  Gemgem.write
end
