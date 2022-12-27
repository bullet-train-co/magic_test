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

      create_sample_test
      update_config_file
      update_layout_templates
      show_install_message
    end

    private

    def create_sample_test
      generate "system_test", "basic"
      test_file = "test/system/basics_test.rb"
      gsub_file test_file, "# ", ""
      gsub_file test_file, "#", ""
      gsub_file test_file, "visiting the index", "getting started"
      gsub_file test_file, "visit basics_url", "visit root_path"
      gsub_file test_file, 'assert_selector "h1", text: "Basic"', "magic_test"
    end

    def update_config_file
      config_file = "test/application_system_test_case.rb"

      gsub_file config_file, "using: :chrome", "using: :headless_chrome"
      gsub_file config_file, "using: :firefox", "using: :headless_firefox"

      gsub_file config_file, "using: :headless_chrome", "using: (ENV['MAGIC_TEST'] ? :chrome : :headless_chrome)"
      gsub_file config_file, "using: :headless_firefox", "using: (ENV['MAGIC_TEST'] ? :firefox : :headless_firefox)"

      gsub_file config_file, "screen_size: [1400, 1400]", "screen_size: (ENV['MAGIC_TEST'] ? [800, 1400] : [1400, 1400])"
    end

    def update_layout_templates
      templates = layout_templates
      string = "    <%= render 'magic_test/support' if Rails.env.test? %>\n"
      templates.each do |file|
        insert_into_file file, string, before: /^\s*<\/head>/
      end
    end

    def layout_templates
      layouts = Dir.glob("#{Rails.root}/app/views/layouts/**/*.html.erb")
      layouts.reject { |file| file =~ /mailer/ }
    end

    def show_install_message
      message = %q(
        We just inserted:
        `<%= render 'magic_test/support' if Rails.env.test? %>`
        before each closing `</head>` tag in your all of your templates in your `layouts` directory.
        If there is another template or partial containing any `<head></head>` tags any where else in
        your project (Example: `views/shared/_head.html.erb`), please paste the render snippet above within the head tags to ensure Magic Test
        will work as expected.
        Run your first Magic Test by typing `MAGIC_TEST=1 rails test test/system/basics_test.rb` or generate an executable
        with `bundle binstubs magic_test` and then run `bin/magic test test/system/basics_test.rb` into your terminal!
        )

      puts message
    end
  end
end
