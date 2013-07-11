# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'acts_as_select/version'

Gem::Specification.new do |spec|
  spec.name          = 'acts_as_select'
  spec.version       = ActsAsSelect::VERSION
  spec.authors       = ['Paul McKibbin']
  spec.email         = ['pmckibbin@gmail.com']
  spec.description   = %q{Creation of automatic selection suitable for drop downs from all column fields in an ActiveRecord table}
  spec.summary       = %q{Automated selection for Activerecord Tables}
  spec.homepage      = 'http://blackrat.org'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
