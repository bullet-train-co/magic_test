require "rails/generators"
require "magic_test/engine"

module MagicTest
  class InstallGenerator < Rails::Generators::Base
    def install
      unless defined?(MagicTest)
        gem_group :test do
          gem "magic_test"
        end
      end

      setup_test_example
      update_app_test_case
      insert_magic_test_partial
      install_message
    end

    private

    def setup_test_example
      generate 'system_test', 'basic'
      gsub_file "test/system/basics_test.rb", "# ", ""
      gsub_file "test/system/basics_test.rb", "#", ""
      gsub_file "test/system/basics_test.rb", "visiting the index", "getting started"
      gsub_file "test/system/basics_test.rb", "visit basics_url", "visit root_path"
      gsub_file "test/system/basics_test.rb", 'assert_selector "h1", text: "Basic"', "magic_test"
    end

    def update_app_test_case
      gsub_file "test/application_system_test_case.rb", "using: :chrome", "using: :headless_chrome"
      gsub_file "test/application_system_test_case.rb", "using: :firefox", "using: :headless_firefox"
      gsub_file "test/application_system_test_case.rb", "using: :headless_chrome", "using: (ENV['MAGIC_TEST'] ? :chrome : :headless_chrome)"
      gsub_file "test/application_system_test_case.rb", "using: :headless_firefox", "using: (ENV['MAGIC_TEST'] ? :firefox : :headless_firefox)"
      gsub_file "test/application_system_test_case.rb", "screen_size: [1400, 1400]", "screen_size: (ENV['MAGIC_TEST'] ? [800, 1400] : [1400, 1400])"
    end

    def insert_magic_test_partial
      templates = view_layout_templates
      string = "    <%= render 'magic_test/support' if Rails.env.test? %>\n"
      templates.each do |file|
        insert_into_file file, string, before: /^\s*<\/head>/
      end
    end

    def view_layout_templates
      layouts = Dir.glob("#{Rails.root}/app/views/layouts/**/*.html.erb")
      layouts.reject { |file| file =~ /mailer/ }
    end

    def install_message
      message = %q(
        We just inserted:
        `<%= render 'magic_test/support' if Rails.env.test? %>`
        before each closing `</head>` tag in your all of your templates in your `layouts` directory.
        If there is another template or partial containing any `<head></head>` tags any where else in
        your project (Example: `views/shared/_head.html.erb`), please paste the render snippet above within the head tags to ensure Magic Test
        will work as expected.
        Run your first Magic Test by typing `bin/magic test test/system/basics_test.rb` into your terminal!
        )
      
      puts message
    end
  end
end
