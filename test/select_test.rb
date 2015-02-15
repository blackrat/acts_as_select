require 'rubygems'
if RUBY_VERSION >= '1.9'
  require 'minitest/autorun'
  require 'active_record'
else
  require 'test/unit'
  require 'activerecord'
  require 'sqlite3'
end
$:.unshift File.dirname(__FILE__) + '/../lib'
require File.dirname(__FILE__) + '/../init'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

def setup_db
  ActiveRecord::Base.logger
  ActiveRecord::Schema.define(:version => 1) do
    create_table :selections do |t|
      t.column :type, :string
      t.column :name, :string
      t.column :description, :string
      t.column :excluded_string, :string
    end
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class Selection < ActiveRecord::Base;
end
class SelectAll < Selection;
end
class SelectIncludeSingle < Selection;
end
class SelectIncludeMulti < Selection;
end
class SelectExcludeSingle < Selection;
end
class SelectExcludeMulti < Selection;
end
class SelectedIncludeExclude < Selection;
end

class SelectTest < (begin MiniTest::Test rescue Test::Unit::TestCase end)
  def setup
    setup_db
    [SelectAll, SelectIncludeSingle, SelectIncludeMulti, SelectExcludeSingle, SelectExcludeMulti, SelectedIncludeExclude].each do |klass|
      klass.create! :name => 'first',  :description => 'First field',  :excluded_string => 'not allowed'
      klass.create! :name => 'second', :description => 'Second field', :excluded_string => 'not allowed'
      klass.create! :name => 'third',  :description => 'Third field',  :excluded_string => 'not allowed'
      klass.create! :name => 'forth',  :description => 'Forth field',  :excluded_string => 'not allowed'
      klass.create! :name => 'fifth',  :description => 'Fifth field',  :excluded_string => 'not allowed'
      klass.create! :name => 'sixth',  :description => 'Sixth field',  :excluded_string => 'not allowed'
    end
  end

  def teardown
    teardown_db
  end

  def selection_ids
    [
      [1, 1],
      [2, 2],
      [3, 3],
      [4, 4],
      [5, 5],
      [6, 6]
    ]
  end

  def selection_names
    [
      ['first', 1],
      ['second', 2],
      ['third', 3],
      ['forth', 4],
      ['fifth', 5],
      ['sixth', 6]
    ]
  end

  def selection_descriptions
    [
      ['First field', 1],
      ['Second field', 2],
      ['Third field', 3],
      ['Forth field', 4],
      ['Fifth field', 5],
      ['Sixth field', 6]
    ]
  end

  def selection_excluded_strings
    [
      ['not allowed', 1],
      ['not allowed', 2],
      ['not allowed', 3],
      ['not allowed', 4],
      ['not allowed', 5],
      ['not allowed', 6]
    ]
  end

  def test_all_names_selection
    SelectAll.acts_as_select
    assert_equal(SelectAll.id_select, selection_ids)
    assert_equal(SelectAll.id_list, selection_ids.map(&:first))
    assert_equal(SelectAll.name_select, selection_names)
    assert_equal(SelectAll.name_list, selection_names.map(&:first))
    assert_equal(SelectAll.description_select, selection_descriptions)
    assert_equal(SelectAll.description_list, selection_descriptions.map(&:first))
    assert_equal(SelectAll.excluded_string_select, selection_excluded_strings)
    assert_equal(SelectAll.excluded_string_list, selection_excluded_strings.map(&:first))
  end

  def test_incorrect_inclusion
    Selection.acts_as_select :include => ['wibble']
    assert_raises(NoMethodError) { Selection.wibble_select }
  end

  def test_single_field_selection
    SelectIncludeSingle.acts_as_select :include => 'name'
    assert_raises(NoMethodError) { SelectIncludeSingle.id_select }
    assert_raises(NoMethodError) { SelectIncludeSingle.id_list }
    assert_equal(SelectIncludeSingle.name_select, selection_names.map { |x| [x[0], x[1]+6] })
    assert_equal(SelectIncludeSingle.name_list, selection_names.map(&:first))
    assert_raises(NoMethodError) { SelectIncludeSingle.description_select }
    assert_raises(NoMethodError) { SelectIncludeSingle.description_list }
    assert_raises(NoMethodError) { SelectIncludeSingle.excluded_string_select }
    assert_raises(NoMethodError) { SelectIncludeSingle.excluded_string_list }
  end

  def test_multi_field_selection
    SelectIncludeMulti.acts_as_select :include => %w(name description)
    assert_raises(NoMethodError) { SelectIncludeMulti.id_select }
    assert_raises(NoMethodError) { SelectIncludeMulti.id_list }
    assert_equal(SelectIncludeMulti.name_select, selection_names.map { |x| [x[0], x[1]+12] })
    assert_equal(SelectIncludeMulti.name_list, selection_names.map(&:first))
    assert_equal(SelectIncludeMulti.description_select, selection_descriptions.map { |x| [x[0], x[1]+12] })
    assert_equal(SelectIncludeMulti.description_list, selection_descriptions.map(&:first))
    assert_raises(NoMethodError) { SelectIncludeMulti.excluded_string_select }
    assert_raises(NoMethodError) { SelectIncludeMulti.excluded_string_list }
  end

  def test_single_field_exclusion
    SelectExcludeSingle.acts_as_select :exclude => 'excluded_string'
    assert_equal(SelectExcludeSingle.id_select, selection_ids.map { |x| [x[0]+18, x[1]+18] })
    assert_equal(SelectExcludeSingle.id_list, selection_ids.map { |x| x[0]+18 })
    assert_equal(SelectExcludeSingle.name_select, selection_names.map { |x| [x[0], x[1]+18] })
    assert_equal(SelectExcludeSingle.name_list, selection_names.map(&:first))
    assert_equal(SelectExcludeSingle.description_select, selection_descriptions.map { |x| [x[0], x[1]+18] })
    assert_equal(SelectExcludeSingle.description_list, selection_descriptions.map(&:first))
    assert_raises(NoMethodError) { SelectExcludeSingle.excluded_string_select }
    assert_raises(NoMethodError) { SelectExcludeSingle.excluded_string_list }
  end

  def test_multi_field_exclusion
    SelectExcludeMulti.acts_as_select :exclude => %w(description excluded_string)
    assert_equal(SelectExcludeMulti.id_select, selection_ids.map { |x| [x[0]+24, x[1]+24] })
    assert_equal(SelectExcludeMulti.id_list, selection_ids.map { |x| x[0]+24 })
    assert_equal(SelectExcludeMulti.name_select, selection_names.map { |x| [x[0], x[1]+24] })
    assert_equal(SelectExcludeMulti.name_list, selection_names.map(&:first))
    assert_raises(NoMethodError) { SelectExcludeMulti.description_select }
    assert_raises(NoMethodError) { SelectExcludeMulti.description_list }
    assert_raises(NoMethodError) { SelectExcludeMulti.excluded_string_select }
    assert_raises(NoMethodError) { SelectExcludeMulti.excluded_string_list }
  end

  def test_include_exclude
    SelectedIncludeExclude.acts_as_select :include => %w(name description), :exclude => %w(description excluded_string)
    assert_raises(NoMethodError) { SelectedIncludeExclude.id_select }
    assert_raises(NoMethodError) { SelectedIncludeExclude.id_list }
    assert_equal(SelectedIncludeExclude.name_select, selection_names.map { |x| [x[0], x[1]+30] })
    assert_equal(SelectedIncludeExclude.name_list, selection_names.map(&:first))
    assert_raises(NoMethodError) { SelectedIncludeExclude.description_select }
    assert_raises(NoMethodError) { SelectedIncludeExclude.description_list }
    assert_raises(NoMethodError) { SelectedIncludeExclude.excluded_string_select }
    assert_raises(NoMethodError) { SelectedIncludeExclude.excluded_string_list }
  end
end

