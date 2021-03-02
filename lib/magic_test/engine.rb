require "magic_test/support"
require "pry"
require "pry-stack_explorer"

module MagicTest
  class Engine < Rails::Engine
    config.after_initialize do
      if ENV["MAGIC_TEST"].present?
        if defined? ActionDispatch::SystemTestCase
          ActionDispatch::SystemTestCase.include MagicTest::Support
        end

        if defined? ActionDispatch::IntegrationTest
          ActionDispatch::IntegrationTest.include MagicTest::Support
        end

        if defined? RSpec
          RSpec.configure do |config|
            config.include MagicTest::Support, type: :system
          end
        end
      end
    end
  end
end
