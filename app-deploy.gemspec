# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{app-deploy}
  s.version = "0.8.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lin Jen-Shin (godfat)"]
  s.date = %q{2011-02-25}
  s.description = %q{rake tasks for deployment}
  s.email = ["godfat (XD) godfat.org"]
  s.extra_rdoc_files = ["CHANGES", "TODO"]
  s.files = [".gitignore", "CHANGES", "README", "Rakefile", "TODO", "app-deploy.gemspec", "example/Rakefile", "example/bin/README", "example/bin/install.sh", "example/bin/remote_install.sh", "example/bin/remote_restart.sh", "example/bin/remote_sh.sh", "example/bin/remote_update.sh", "example/bin/restart.sh", "example/bin/start.sh", "example/bin/update.sh", "example/daemon_cluster.yaml", "example/rack_cluster.yaml", "lib/app-deploy.rb", "lib/app-deploy/daemon.rake", "lib/app-deploy/daemon.rb", "lib/app-deploy/daemon_cluster.rb", "lib/app-deploy/deploy.rake", "lib/app-deploy/deprecated/merb.rake", "lib/app-deploy/deprecated/mongrel.rake", "lib/app-deploy/gem.rake", "lib/app-deploy/git.rake", "lib/app-deploy/install.rake", "lib/app-deploy/nginx.rake", "lib/app-deploy/rack.rake", "lib/app-deploy/rack_cluster.rb", "lib/app-deploy/remote.rake", "lib/app-deploy/server.rake", "lib/app-deploy/signal.rake", "lib/app-deploy/thin.rake", "lib/app-deploy/unicorn.rake", "lib/app-deploy/utils.rb", "lib/app-deploy/version.rb", "task/gemgem.rb"]
  s.homepage = %q{http://github.com/godfat/app-deploy}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{rake tasks for deployment}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
