require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: (ENV['MAGIC_TEST'] ? :chrome : :headless_chrome), screen_size: (ENV['MAGIC_TEST'] ? [800, 1400] : [1400, 1400])
end
