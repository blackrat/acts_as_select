require 'rake'
require 'rake/testtask'

desc 'Default: run all tests.'
task :default=>:test

desc 'Test acts_as_select plugin'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end