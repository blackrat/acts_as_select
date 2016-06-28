# ActsAsSelect

Acts_as_select allows you to automatically use the columns from an activerecord reference table with a
descriptive name and primary key ids

It generates <column_name>_select methods for each permitted column, which maps that column and its primary
key to a 2d array suitable for use in an option_select or as a container for options_for_select.

Additionally, it can generate a list of items using <column_name>_list methods.

All of these options can be used to terminate scopes or other database methods.

## Installation

Add this line to your application's Gemfile:

    gem 'acts_as_select'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install acts_as_select

## Usage
Include acts_as_select in your model file.

    class Person < ActiveRecord::Base
      acts_as_select
    end

This makes all columns database accessible. You can return selectable options by calling <column_name>_select, or
obtain a list of the contents of a column by calling <column_name>_list

### Options
acts_as_select takes two options to allow for finer grained control over which methods are created and allows for scoping to restrict or change order.

    :include => [column_list]

This specifies which columns have _select and _list methods created for them. All other columns are excluded
Note: if you include a column name that doesn't exist, it will raise a NoMethodError exception when you try to use it.

    :exclude => [column_list]

This specifies which columns are excluded from having the _select and _list methods created.

    :include => [column_list_1], :exclude => [column_list_2]

When both options are supplied, the exclusion happens after the inclusion. That is, if there are overlapping column
names in both lists, these columns are excluded, regardless of the order of the options.

### Example

With this database table

    | id | name |       email      |
    |----|------|------------------|
    | 1  | Bob  | bob@example.com  |
    | 2  | Jen  | jen@example.com  |
    | 3 | april | sheri@example.com|

And this model

    class Person < ActiveRecord::Base
      acts_as_select :include=>['name', 'email'], :exclude=>'id'
    end

This would create two select methods, `name_select` and `email_select`,
and four list methods `name_list`, `name_objects`, `email_list` and `email_objects`.

    Person.name_select
    #=> [["Bob", 1], ["Jen", 2], ["april", 3]]
    Person.email_select
    #=> [["bob@example.com", 1], ["jen@example.com", 2], ["april@example.com",3]]
    Person.name_list
    #=> ['Bob','Jen','april']
    
The name_objects is a special form that returns objects of the same class as the model, but with only the 
quoted name and id fields. Effectively it returns the the same values as the name_select, but as an ActiveRecord 
Relation object form with only name and id relationships, which can then be mapped out to other forms
    
    Person.name_objects
    #=> <Person::ActiveRecord_Relation:0x000000002911234>
    Person.name_objects.to_a
    #=> [<Person:0x00000002917998>,<Person:0x00000002918730>,<Person:0x0000000267ed58>]
    Person.name_objects.to_a.map(&:attributes)
    #=> [{'id'=>1, 'name'=>'Bob'},{'id'=>2, 'name'=>'Jen'},{'id'=>3, 'name'=>'april'}] 

This is the right format for use in a select tag and friends

    select :order, :customer, Person.name_select

If you want to change the sorting of the table, based on a non-chosen field (for example), you can use
arel_scopes to do so. The same `email_select` and `email_list` can have their contents sorted by the 
lowercase corrected name (for example)

    Person.order('lower(name) asc').email_select
    #=> [["sheri@example.com", 3], ["bob@example.com", 1], ["jen@example.com", 2]]

You can combine it with any other named_scopes, scopes or scoping methods, but as it maps to an array
for use in a select dropdown, it will need to be the last method on the chain.

    Person.where(...).group(...).order(...).name_select
    
The one exception to this is the name_objects format, which returns a relation and hence
can be used inline with the rest of the scopes.

    Person.name_objects.order('name asc').to_sql
    #=> "SELECT name, id FROM "people" ORDER BY name asc"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
