MagicTest.setup do |config|
  config.jquery_already_included = <%= jquery_already_included ? 'true' : 'false' %>
end if Rails.env.test?
