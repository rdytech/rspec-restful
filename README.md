# RSpec-Restful

Simple test helpers that provide easy speccing of basic RESTful controllers that
only operate on a single ActiveRecord object.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec_restful'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install restful_test_helpers

## Usage

In `spec/rails_helper.rb` add the following lines:
```ruby
require 'rspec_restful'

#...

RSpec.configure do |config|
  config.include RspecRestful::ValidityHelpers, type: :controller
  config.extend RspecRestful::ControllerHelpers, type: :controller
end
```

In your controller specs, the following macros are now available to test
the 7 basic REST actions:

```ruby
RSpec.describe WidgetsController, type: :controller do
  let(:test_widget_params) {{ name: "Goat Herder" }}

  describe_restful_index_action
  describe_restful_show_action(Widget)
  describe_restful_new_action
  describe_restful_create_action(Widget, url_method: :widgets_path)
  describe_restful_edit_action(Widget)
  describe_restful_update_action(Widget, url_method: :widgets_path, object_method: :widget)
  describe_restful_destroy_action(Widget, url_method: :widgets_path)
end
```

This expects that a FactoryGirl factory named `:widget` is available to create
objects, however if an `:object_method` option is passed, this will be called
instead.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/restful_test_helpers/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
