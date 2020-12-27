# -*- encoding: utf-8 -*-
# stub: ar_outer_joins 0.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "ar_outer_joins".freeze
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jonas Nicklas".freeze, "Elabs AB".freeze]
  s.date = "2014-09-08"
  s.description = "Adds the missing outer_joins method to ActiveRecord".freeze
  s.email = ["jonas.nicklas@gmail.com".freeze, "dev@elabs.se".freeze]
  s.homepage = "http://github.com/elabs/ar_outer_joins".freeze
  s.rubygems_version = "3.2.3".freeze
  s.summary = "outer_joins for ActiveRecord".freeze

  s.installed_by_version = "3.2.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<activerecord>.freeze, [">= 3.2"])
    s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
    s.add_development_dependency(%q<pry>.freeze, [">= 0"])
  else
    s.add_dependency(%q<activerecord>.freeze, [">= 3.2"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
    s.add_dependency(%q<pry>.freeze, [">= 0"])
  end
end
