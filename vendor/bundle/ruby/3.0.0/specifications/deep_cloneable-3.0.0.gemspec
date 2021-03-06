# -*- encoding: utf-8 -*-
# stub: deep_cloneable 3.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "deep_cloneable".freeze
  s.version = "3.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Reinier de Lange".freeze]
  s.date = "2019-08-18"
  s.description = "Extends the functionality of ActiveRecord::Base#dup to perform a deep clone that includes user specified associations. ".freeze
  s.email = "rjdelange@icloud.com".freeze
  s.extra_rdoc_files = ["LICENSE".freeze]
  s.files = ["LICENSE".freeze]
  s.homepage = "http://github.com/moiristo/deep_cloneable".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.2.3".freeze
  s.summary = "This gem gives every ActiveRecord::Base object the possibility to do a deep clone.".freeze

  s.installed_by_version = "3.2.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<activerecord>.freeze, [">= 3.1.0", "< 7"])
  else
    s.add_dependency(%q<activerecord>.freeze, [">= 3.1.0", "< 7"])
  end
end
