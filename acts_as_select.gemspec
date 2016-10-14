# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
require File.dirname(__FILE__) + '/lib/active_record/acts/select'

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'acts_as_select'
  spec.version       = ActiveRecord::Acts::Select::VERSION
  spec.authors       = ['Paul McKibbin']
  spec.email         = ['pmckibbin@gmail.com']
  spec.description   = %q{Creation of automatic selection suitable for drop downs from column fields in an ActiveRecord table}
  spec.summary       = %q{Automated selection for Activerecord Tables}
  spec.homepage      = 'http://blackrat.org'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'sqlite3'
  if RUBY_VERSION >= '2.2.2'
    spec.add_development_dependency 'minitest'
    spec.add_development_dependency 'activerecord'
  elsif RUBY_VERSION >= '1.9'
    spec.add_development_dependency 'minitest'
    spec.add_development_dependency 'activerecord', '~> 3.0'
  else
    spec.add_development_dependency 'test-unit'
    spec.add_development_dependency 'activerecord', '~> 2.3'
  end
end
