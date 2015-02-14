require 'minitest/autorun'
require 'rubygems'
require 'active_record'

$:.unshift File.dirname(__FILE__) + '/../lib'
require File.dirname(__FILE__) + '/../init'

class Test::Unit::TestCase
  def assert_queries(num = 1)
    $query_count = 0
    yield
  ensure
    assert_equal num, $query_count, "#{$query_count} instead of #{num} queries were executed."
  end

  def assert_no_queries(&block)
    assert_queries(0, &block)
  end
end

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")

# AR keeps printing annoying schema statements
$stdout = StringIO.new

def setup_db
  ActiveRecord::Base.logger
  ActiveRecord::Schema.define(:version => 1) do
    create_table :selections do |t|
      t.column :name, :string
      t.column :description, :string
      t.column :excluded_string, :string
      t.column :permitted_int, :integer
      t.column :excluded_int, :integer
    end
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class Selection < ActiveRecord::Base
end

class AllFieldTreeTest < Test::Unit::TestCase
  acts_as_select

  def setup
    setup_db
    Selection.create! :name=>'first',:decription=>'First field',:excluded_string=>'not allowed',:permitted_int=>1,:excluded_int=>999
    Selection.create! :name=>'second',:decription=>'Second field',:excluded_string=>'not allowed',:permitted_int=>2,:excluded_int=>998
    Selection.create! :name=>'third',:decription=>'Third field',:excluded_string=>'not allowed',:permitted_int=>3,:excluded_int=>997
    Selection.create! :name=>'forth',:decription=>'Forth field',:excluded_string=>'not allowed',:permitted_int=>4,:excluded_int=>996
    Selection.create! :name=>'fifth',:decription=>'Fifth field',:excluded_string=>'not allowed',:permitted_int=>5,:excluded_int=>995
    Selection.create! :name=>'sixth',:decription=>'Sixth field',:excluded_string=>'not allowed',:permitted_int=>6,:excluded_int=>994
  end

  def teardown
    teardown_db
  end

end
