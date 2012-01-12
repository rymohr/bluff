# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'bluff/version'

Gem::Specification.new do |s|
  s.name        = 'bluff'
  s.version     = Bluff::VERSION
  s.authors     = ['Ryan Mohr']
  s.email       = ['ryan.mohr@gmail.com']
  s.homepage    = ''
  s.summary     = %q{A single source of lies for all your testing needs}
  s.description = %q{}

  s.rubyforge_project = 'bluff'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ['lib']
  
  s.add_development_dependency 'activesupport', '~> 3.0'
  s.add_development_dependency 'rspec', '~> 2.8' # can't we just use rspec instead?
  s.add_development_dependency 'faker', '~> 1.0'
end