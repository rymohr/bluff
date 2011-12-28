# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bluff/version"

Gem::Specification.new do |s|
  s.name        = "bluff"
  s.version     = Bluff::VERSION
  s.authors     = ["Ryan Mohr"]
  s.email       = ["ryan.mohr@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{A single source of lies for all your testing needs}
  s.description = %q{}

  s.rubyforge_project = "bluff"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
