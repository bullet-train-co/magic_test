# Super Test

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/super_test`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Super Test currently requires your application to have jQuery enabled.

Add this line to your application's Gemfile:

```ruby
gem 'super_test'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install super_test

Once you have the gem included, add the following at the end of the `<head>` block in any layouts your application uses (e.g. `app/views/layouts/*.html.erb`):

```
<%= render 'super_test/javascript_helpers' if Rails.env.test? %>
```

## Usage

To spin up a new test:

```
rails test:system:write managing_new_thing
```

This will:

 - Use standard Rails scaffolding to create the system test file if it doesn't already exist.
 - Stub out the test to include a call to `write_test_interactively`.
 - Open the test in Atom. (We'll make this configurable shortly.)
 - Start running the test.
 - Break into a debugging session in the context of the executing test.
 - Open a Chrome session once you execute `visit root_path`.

You're now free to type Capybara commands in the debugger and see their results in the Chrome browser. If you type something and you're with the result, type `ok` and hit enter to have the last line of code you wrote added to the test.

When you're done writing the test interactively, you can press <kbd>Control</kbd> + <kbd>D</kbd> to finish running the test.
    
You can re-run `rails test:system:write managing_new_thing` to have the test execute up until the point where you stopped, and then re-enter the debugging session to continue writing the test. This is a great workflow for testing your work as you go.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bullet-train-co/super-test. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Super Test project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bullet-train-co/super-test/blob/master/CODE_OF_CONDUCT.md).
