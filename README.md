# ActsAsSelect

acts_as_select creates a select style for each column in the database (except the primary key) and returns a 2d array
in a form suitable for use in a selection drop down (hence the name)

## Installation

Add this line to your application's Gemfile:

    gem 'acts_as_select'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install acts_as_select

## Usage

Include acts_as_select in your model file. This makes all columns accessible by calling select_<column_name>

### Example

With this database table

    | id | name |      email      |
    |----|------|-----------------|
    | 1  | Bob  | bob@example.com |
    | 2  | Jen  | jen@example.com |

And this model

    class Person < ActiveRecord::Base
      acts_as_select
    end

This would create two methods, `name_select` and `email_select`

    Person.name_select
    #=> [["Bob", 1], ["Jen", 2]]
    Person.email_select
    #=> [["bob@example.com", 1], ["jen@example.com", 2]]

This is the right format for use in a select tag and friends

    select :order, :customer, Person.name_select

You can even combine it with scopes

    Person.where(...).name_select

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
