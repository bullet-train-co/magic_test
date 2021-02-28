require "magic_test/version"
require "magic_test/railtie"
require "magic_test/engine"
require "magic_test/support"

module MagicTest
  class Error < StandardError; end

  mattr_accessor :jquery_already_included
  @@jquery_already_included = false

  def self.setup
    yield self
  end
end
