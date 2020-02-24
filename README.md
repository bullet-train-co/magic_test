# Super Test

Super Test allows you to write Rails system tests interactively through a combination of trial-and-error in a debugger session and also just simple clicking around in the application being tested, all without the slowness of constantly restarting the testing environment.

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

 1. Use standard Rails scaffolding to create the system test file if it doesn't already exist.
 2. Stub out the test to include a call to `write_test_interactively`.
 3. Open the test in Atom. (We'll make this configurable shortly.)
 4. Start running the test.
 5. Break into a debugging session in the context of the executing test.
 6. Open a Chrome session once you execute `visit root_path`.
 
This results in three windows:

 1. *A debugger* where you can interactively write Capybara test code in the same context it would normally run.
 2. *A browser* where you can click around the application and have your actions automatically converted into Capybara code.
 3. *A editor* where you mostly just watch test code appear magically, but you can also edit it by hand should you need to.

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
