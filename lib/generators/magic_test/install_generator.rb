require "rails/generators"

module MagicTest
  class InstallGenerator < Rails::Generators::Base

    def install
      unless defined?(MagicTest)
        gem_group :test do
          gem "magic_test"
        end
      end
      generate "system_test", "basics"
      replace_test if File.exist?("test/system/basics_test.rb")
      insert_in_layout
    end

    private

    def insert_in_layout
      files = layouts
      string = "    <%= render 'magic_test/support' if Rails.env.test? %>\n"
      files.each do |file|
        insert_into_file file, string, before: /^\s*<\/head>/
      end
    end

    def replace_test
      gsub_file "test/system/basics_test.rb", "# ", ""
      gsub_file "test/system/basics_test.rb", "#", ""
      gsub_file "test/system/basics_test.rb", "visiting the index", "getting started"
      gsub_file "test/system/basics_test.rb", "visit basics_url", "visit root_url"
      gsub_file "test/system/basics_test.rb", 'assert_selector "h1", text: "Basics"', "magic_test"

      gsub_file "test/application_system_test_case.rb", "using: :headless_chrome", "using: (ENV['SHOW_TESTS'] ? :chrome : :headless_chrome)"
      gsub_file "test/application_system_test_case.rb", "using: :headless_firefox", "using: (ENV['SHOW_TESTS'] ? :firefox : :headless_firefox)"
    end

    def layouts
      files = Dir.glob("#{Rails.root}/app/views/layouts/**/*.html.erb")
      files.reject { |file| file =~ /mailer/ }
    end
  end
end
