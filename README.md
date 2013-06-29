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

Example:
  class Dummy < ActiveRecord::Base
  acts_as_select
  end

If dummy had a name and description defined in the database, this would create
the methods: select_description, select_name

These can then be used anywhere you need a select.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
