# Magic Test

Magic Test allows you to write Rails system tests interactively through a combination of trial-and-error in a debugger session and also just simple clicking around in the application being tested, all without the slowness of constantly restarting the testing environment. You can [see some videos of it in action](https://twitter.com/andrewculver/status/1366062684802846721)!

> Magic Test is still in early development, and that includes the documentation. Any questions you have that aren't already address in the documentation should be [opened as issues](https://github.com/bullet-train-co/magic_test/issues/new) so they can be appropriately addressed in the documentation. 

Magic Test was created by [Andrew Culver](http://twitter.com/andrewculver) and [Adam Pallozzi](https://twitter.com/adampallozzi).

## Sponsored By

<a href="https://bullettrain.co" target="_blank">
  <img src="https://github.com/CanCanCommunity/cancancan/raw/develop/logo/bullet_train.png" alt="Bullet Train" width="400"/>
</a>
<br/>
<br/>

> Would you like to support Magic Test development and have your logo featured here? [Reach out!](http://twitter.com/andrewculver)

## Installation

Add this line to your application’s `Gemfile`:

```ruby
gem 'magic_test', group: :test
```

Then run the following in your shell:

```
bundle install
```

Next, run the install generator:

```
rails g magic_test:install
```

With this we will:

 - Create a sample system test at `test/system/basics_test.rb` that invokes Magic Test.
 - If your application was previously configured to run system tests with `:headless_chrome` or `:headless_firefox`, we will attempt to update your configuration so you can see the browser when you run tests with `MAGIC_TEST=1` as an environment variable.

 Finally, because it’s hard for us to do automatically, you will need to add the following before any closing `</head>` tags in any of the files in `app/views/layouts`:

```ruby+erb
<%= render 'magic_test/support' if Rails.env.test? %>
```

You should be done now! To review what we’ve done for you, be sure to do a `git diff` at this point and make sure our generators didn’t break anything!

## Usage

### Running the Example Test

1. Open `test/system/basics_test.rb` in your editor of choice.
2. Run `MAGIC_TEST=1 rails test:system test/system/basics_test.rb` on the shell.

This results in three windows:

  1. **A debugger** where you can interactively write Capybara test code in the same context it would normally run.
  2. **A browser** where you can click around the application and have your actions automatically converted into Capybara code.
  3. **A editor** where you mostly just watch test code appear magically, but you can also edit it by hand should you need to.

If you have the screen real estate, we recommend organizing the three windows so you can see them all at the same time. This is the intended Magic Test developer experience.

> #### Using Magic Test in New or Existing Tests
> Just add a call to `magic_test` anywhere you want to start interactively developing test behavior and run the test the same way we've described above.

### Writing Tests Manually in the Debugger Console

You’re now free to issue Capybara commands in the debugger and see their results in the Chrome browser. If you type something and you’re happy with the result, type `ok` and hit enter to have the last line or block of code you wrote added to the test.

When you’re done writing the test interactively, you can press <kbd>Control</kbd> + <kbd>D</kbd> to finish running the test.

You can re-run `MAGIC_TEST=1 rails test:system test/system/basics_test.rb` to have the test execute up until the point where you stopped, and then re-enter the debugging session to continue writing the test. This is a great workflow for testing your work as you go.

When you’re actually done writing the test, be sure to remove the `magic_test` reference in the test file.

### Recording Your Test Actions in the Browser

You can also write your tests by simply using your app in the browser window. This isn’t perfect yet by any means, but you’ll definitely get a sense for where we’re going with this and it’s already a pretty magical experience and a major productivity booster.

You can click on buttons, click on links, fill in forms, and do many other things the way you would as a normal user. You may find there are certain shortcomings here, but our goal is to tackle all of those edge cases over time.

### Generating Assertions in the Browser

If you want to add an assertion that some content exists on the page, simply highlight some text and press <kbd>Control</kbd><kbd>Shift</kbd> + <kbd>A</kbd>. You should see an alert dialog confirming the assertion has been generated.

### Flushing In Browser Actions and Assertions to the Test File

The interactive actions you make in your app are not automatically written to your test.  When you are ready to write your actions out to the test, go to the terminal window and type `flush`.  This will flush all your recent actions out to the test file. It’s still early days for Magic Test, so you may find you need to clean up some of the output. Please don’t hesitate to [submit new issues](https://github.com/bullet-train-co/magic_test/issues/new) highlighting these scenarios so we can try to improve the results.

### Ambiguous Labels and Elements

When generating test code, we check to ensure a given label or element identifier won’t result in multiple or ambiguous matches the next time a test runs. If that situation arises, we’ll try to generate the appropriate `within` blocks and selectors to ensure the target button or field is disambiguated.

## Acknowledgements
We'd like to thank [Florian Plank](https://twitter.com/polarblau), the author of [Capycorder](https://github.com/polarblau/capycorder). His earlier attempt at the same concept (implemented via a Chrome extension) was ahead of its time and provided us with great inspiration and lessons learned when solving this problem from another angle.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bullet-train-co/magic_test. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The Ruby Gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
