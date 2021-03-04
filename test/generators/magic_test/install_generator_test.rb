# require "test_helper"
# class MagicTest::InstallGeneratorTest < ::Rails::Generators::TestCase
#   tests MagicTest::InstallGenerator
#   destination File.expand_path("../../dummy", File.dirname(__FILE__))

#   test "replaces the default test with magic_test content" do
#     # Add default application system case
#     FileUtils.copy_file('test/support/application_system_test_case.rb', File.join(destination_root, 'test/application_system_test_case.rb'))
#     run_generator

#     test_file = File.join(destination_root, 'test/system/basics_test.rb')
#     config_file = File.join(destination_root, 'test/application_system_test_case.rb')
#     assert_file test_file, /magic_test/
#     assert_file config_file, /ENV\['SHOW_TESTS'\]/
#     File.delete(test_file) # if File.exist?(test_file)
#     File.delete(config_file) # if File.exist?(config_file)
#   end

#   test "inserts the required script tags in the HTML layouts" do
#     # Add default layouts
#     FileUtils.copy_entry 'test/support/layouts', File.join(destination_root, 'app/views/layouts')
#     run_generator

#     regex = /^\s*\<%= *render \'magic_test\/support\'.*\s*\<\/head>/
#     # HTML layouts are recursively being added the needed line
#     assert_file_contains('application.html.erb', regex)
#     assert_file_contains('some_other_layout.html.erb.erb', regex)
#     assert_file_contains('admin/application.html.erb', regex)
#     # Other files are left untouched
#     assert_file_unmodified('mailer.html.erb', regex)
#     assert_file_unmodified('some_other_file.txt', regex)
#     # clear_files
#     FileUtils.remove_dir File.join(destination_root, 'app/views/layouts')
#   end

#   def assert_file_unmodified(filename, regex)
#     assert_file File.join(destination_root, "app/views/layouts/#{filename}") do |content| 
#       assert_no_match(regex, content)
#     end
#   end

#   def assert_file_contains(filename, regex)
#     assert_file File.join(destination_root, "app/views/layouts/#{filename}") do |content|
#       assert_match(regex, content)
#     end
#   end
# end