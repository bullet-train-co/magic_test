require "test_helper"
require "rails/generators/test_case"
require "generators/magic_test/install_generator"

module MagicTest
  class InstallGeneratorTest < Rails::Generators::TestCase
    tests MagicTest::InstallGenerator
    destination File.expand_path("../../dummy", File.dirname(__FILE__))

    test "install magic test" do
      puts "\n = = Running generator"

      # During test these files needs to not exists or test hangs, so we delete it beforehand
      # so it can properly create it ensuring it creates it with the text and method we intend
      # it to have
      if File.exist?(File.join(destination_root, "test/system/basics_test.rb"))
        FileUtils.cd(File.join(destination_root, "test/system")) do
          FileUtils.rm_rf("basics_test.rb")
        end
      end

      if File.exist?(File.join(destination_root, "test/application_system_test_case.rb"))
        FileUtils.cd(File.join(destination_root, "test")) do
          FileUtils.rm_rf("application_system_test_case.rb")
        end
      end

      # Layout files need to be in place so generator can insert line, or else test hangs, generator
      # does not create the layout files, only inserts method into them
      FileUtils.copy_entry "test/support/layouts", File.join(destination_root, "app/views/layouts")
      FileUtils.copy_entry "test/support/application_system_test_case.rb", File.join(destination_root, "test/application_system_test_case.rb")

      run_generator

      puts "\n = = Generator executed"

      # Assertions
      #
      # Basics test contains magic_test method
      method = /magic_test/
      test_file = File.join(destination_root, "test/system/basics_test.rb")
      assert_file(test_file, method)

      # application_system_test_case contains Magic Test env variable
      return unless File.exist?(File.join(destination_root, "test/application_system_test_case.rb"))

      env_var = /ENV\['MAGIC_TEST'\]/
      config_file = File.join(destination_root, "test/application_system_test_case.rb")
      assert_file(config_file, env_var)

      # Ensure layouts container the render method for the partial
      regex = /^\s*<%= *render 'magic_test\/support'.*\s*<\/head>/

      assert_file_contains("application.html.erb", regex)
      assert_file_contains("dashboard.html.erb", regex)
      assert_file_contains("admin/application.html.erb", regex)

      assert_file_unmodified("mailer.html.erb", regex)
      assert_file_unmodified("application.txt", regex)

      # Removing this files after assertions lets us know they did not exist in the dummy app
      # before running test, so we know they were not pre-populated witht the render method
      # we were asserting above. Omitting application.html.erb file from test is ok.
      FileUtils.cd(File.join(destination_root, "app/views/layouts")) do
        FileUtils.rm_rf(["application.txt", "dashboard.html.erb", "admin"])
      end

      puts "\n = = Assertions asserted"
    end

    def assert_file_contains(filename, regex)
      assert_file File.join(destination_root, "app/views/layouts/#{filename}") do |content|
        assert_match(regex, content)
      end
    end

    def assert_file_unmodified(filename, regex)
      assert_file File.join(destination_root, "app/views/layouts/#{filename}") do |content|
        assert_no_match(regex, content)
      end
    end
  end
end
