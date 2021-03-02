require "rails/generators"
require "magic_test/engine"

module MagicTest
  class InstallGenerator < Rails::Generators::Base
    def self.source_paths
      [MagicTest::Engine.root, File.expand_path("../templates", __FILE__)]
    end

    def install
      unless defined?(MagicTest)
        gem_group :test do
          gem "magic_test"
        end
      end

      generate "system_test", "basic"
      gsub_file "test/system/basics_test.rb", "# ", ""
      gsub_file "test/system/basics_test.rb", "#", ""
      gsub_file "test/system/basics_test.rb", "visiting the index", "getting started"
      gsub_file "test/system/basics_test.rb", "visit basics_url", "visit root_url"
      gsub_file "test/system/basics_test.rb", 'assert_selector "h1", text: "Basic"', "magic_test"

      gsub_file "test/application_system_test_case.rb", "using: :headless_chrome", "using: (ENV['SHOW_TESTS'] ? :chrome : :headless_chrome)"
      gsub_file "test/application_system_test_case.rb", "using: :headless_firefox", "using: (ENV['SHOW_TESTS'] ? :firefox : :headless_firefox)"
    end
  end
end
