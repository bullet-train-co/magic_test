require "magic_test/version"
require "magic_test/railtie"
require "magic_test/engine"
require "magic_test/support"

module MagicTest
  class Error < StandardError; end

  def self.setup
    yield self
  end
end
