# ActsAsSelect

  Creation of automatic selection-like 2D arrays suitable for drop downs from all column fields in an ActiveRecord table

## Installation

Add this line to your application's Gemfile:

    gem 'acts_as_select'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install acts_as_select

## Usage

    In the ActiveRecord model for the reference data, add in acts_as_select to allow all fields to be select items

    e.g.

    class Dummy < ActiveRecord::Base
      acts_as_select
    end

    If the Dummy model contains the columns name and description, this will create name_select and description_select methods
    which will return 2D arrays with the column and primary key details.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
