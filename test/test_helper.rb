ENV["RAILS_ENV"] = "test"

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "magic_test"

require "minitest/autorun"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
