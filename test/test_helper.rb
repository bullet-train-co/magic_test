require "rails"
require "rails/test_help"
require 'rails/test_unit/railtie'
require 'minitest'
require "rails/generators/test_case"

require "minitest/autorun"
require 'generators/magic_test/install_generator'
require "magic_test"

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
$LOAD_PATH.unshift File.expand_path("../support", __FILE__)