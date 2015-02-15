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
acts_as_select takes two options to allow for finer grained control over which methods are created:

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

    | id | name |      email      |
    |----|------|-----------------|
    | 1  | Bob  | bob@example.com |
    | 2  | Jen  | jen@example.com |

And this model

    class Person < ActiveRecord::Base
      acts_as_select :include=>['name', 'email'], :exclude=>['id']
    end

This would create two select methods, `name_select` and `email_select`,
and three list methods `name_list` and `email_list`

    Person.name_select
    #=> [["Bob", 1], ["Jen", 2]]
    Person.email_select
    #=> [["bob@example.com", 1], ["jen@example.com", 2]]

This is the right format for use in a select tag and friends

    select :order, :customer, Person.name_select

You can combine it with scopes

    Person.where(...).name_select

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
