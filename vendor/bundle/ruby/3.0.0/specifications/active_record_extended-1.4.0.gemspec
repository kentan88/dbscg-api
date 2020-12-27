# -*- encoding: utf-8 -*-
# stub: active_record_extended 1.4.0 ruby lib

Gem::Specification.new do |s|
  s.name = "active_record_extended".freeze
  s.version = "1.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["George Protacio-Karaszi".freeze, "Dan McClain".freeze, "Olivier El Mekki".freeze]
  s.date = "2019-11-06"
  s.description = "Adds extended functionality to Activerecord Postgres implementation".freeze
  s.email = ["georgekaraszi@gmail.com".freeze, "git@danmcclain.net".freeze, "olivier@el-mekki.com".freeze]
  s.homepage = "https://github.com/georgekaraszi/ActiveRecordExtended".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.2.3".freeze
  s.summary = "Adds extended functionality to Activerecord Postgres implementation".freeze

  s.installed_by_version = "3.2.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<activerecord>.freeze, [">= 5.0", "< 6.1"])
    s.add_runtime_dependency(%q<ar_outer_joins>.freeze, ["~> 0.2"])
    s.add_runtime_dependency(%q<pg>.freeze, ["< 2.0"])
    s.add_development_dependency(%q<bundler>.freeze, [">= 1.16", "< 2.1"])
    s.add_development_dependency(%q<database_cleaner>.freeze, ["~> 1.6"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.16"])
  else
    s.add_dependency(%q<activerecord>.freeze, [">= 5.0", "< 6.1"])
    s.add_dependency(%q<ar_outer_joins>.freeze, ["~> 0.2"])
    s.add_dependency(%q<pg>.freeze, ["< 2.0"])
    s.add_dependency(%q<bundler>.freeze, [">= 1.16", "< 2.1"])
    s.add_dependency(%q<database_cleaner>.freeze, ["~> 1.6"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.16"])
  end
end
