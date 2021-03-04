require "test_helper"

class MagicTest::InstallGeneratorTest < ::Rails::Generators::TestCase
  tests MagicTest::Generators::InstallGenerator
  destination File.expand_path("../../dummy", File.dirname(__FILE__))

  test "replaces the default test with magic_test content" do
    run_generator

    assert_file File.join(destination_root, 'test/system/basics_test.rb'), /magic_test/
    assert_file File.join(destination_root, 'test/system/basics_test.rb'), /ENV\['SHOW_TESTS'\]/
  end

  test "inserts the required script tags in the HTML layouts" do
    add_default_files
    run_generator

    regex = /^\s*\<%= *render \'magic_test\/support\'.*\s*\<\/head>/
    # HTML layouts are recursively being added the needed line
    assert_file File.join(destination_root, 'app/views/layouts/application.html.erb'), regex
    assert_file File.join(destination_root, 'app/views/layouts/admin/application.html.erb'), regex
    assert_file File.join(destination_root, 'app/views/layouts/admin/some_other_layout.html.erb'), regex
    # Other files are left untouched
    assert_file_unmodified('mailer.html.erb', regex)
    assert_file_unmodified('some_other_file.txt', regex)
    clear_files
  end

  def add_default_files
    FileUtils.copy_entry 'test/support/layouts', File.join(destination_root, 'app/views/layouts')
  end

  def clear_files
    FileUtils.remove_dir File.join(destination_root, 'app/views/layouts')
  end

  def assert_file_unmodified(filename, regex)
    assert_file File.join(destination_root, "app/views/layouts/admin/#{file_name}") do |content| 
      assert_no_match(regex, content)
    end
  end
end