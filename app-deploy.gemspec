# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{app-deploy}
  s.version = "0.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Lin Jen-Shin (aka godfat 真常)"]
  s.date = %q{2009-12-16}
  s.description = %q{ rake tasks for deployment}
  s.email = %q{godfat (XD) godfat.org}
  s.extra_rdoc_files = ["CHANGES", "README", "Rakefile", "TODO", "app-deploy.gemspec", "example/Rakefile", "example/bin/install.sh", "example/bin/remote_install.sh", "example/bin/remote_update.sh", "example/bin/start.sh", "example/bin/update.sh", "example/daemon_cluster.yaml", "example/rack_cluster.yaml", "lib/app-deploy/daemon.rake", "lib/app-deploy/deploy.rake", "lib/app-deploy/deprecated/merb.rake", "lib/app-deploy/deprecated/mongrel.rake", "lib/app-deploy/gem.rake", "lib/app-deploy/git.rake", "lib/app-deploy/install.rake", "lib/app-deploy/nginx.rake", "lib/app-deploy/rack.rake", "lib/app-deploy/server.rake", "lib/app-deploy/signal.rake", "lib/app-deploy/thin.rake", "lib/app-deploy/unicorn.rake"]
  s.files = ["CHANGES", "README", "Rakefile", "TODO", "app-deploy.gemspec", "example/Rakefile", "example/bin/install.sh", "example/bin/remote_install.sh", "example/bin/remote_update.sh", "example/bin/start.sh", "example/bin/update.sh", "example/daemon_cluster.yaml", "example/rack_cluster.yaml", "lib/app-deploy.rb", "lib/app-deploy/daemon.rake", "lib/app-deploy/daemon.rb", "lib/app-deploy/daemon_cluster.rb", "lib/app-deploy/deploy.rake", "lib/app-deploy/deprecated/merb.rake", "lib/app-deploy/deprecated/mongrel.rake", "lib/app-deploy/gem.rake", "lib/app-deploy/git.rake", "lib/app-deploy/install.rake", "lib/app-deploy/nginx.rake", "lib/app-deploy/rack.rake", "lib/app-deploy/rack_cluster.rb", "lib/app-deploy/server.rake", "lib/app-deploy/signal.rake", "lib/app-deploy/thin.rake", "lib/app-deploy/unicorn.rake", "lib/app-deploy/utils.rb", "lib/app-deploy/version.rb"]
  s.homepage = %q{http://github.com/godfat/app-deploy}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{app-deploy}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{rake tasks for deployment}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bones>, [">= 3.2.0"])
    else
      s.add_dependency(%q<bones>, [">= 3.2.0"])
    end
  else
    s.add_dependency(%q<bones>, [">= 3.2.0"])
  end
end
