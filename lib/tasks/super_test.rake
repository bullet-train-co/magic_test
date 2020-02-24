unless Rake::Task.task_defined?('test:system:write') # prevent double-loading/execution
  namespace :test do
    namespace :system do
      desc "Write a system test interactively"
      task :write => :environment do
        # TODO figure out a way to get rid of this by guessing the filename that rails would generate.
        # TODO this is really slow.
        puts output = `yes n | rails generate system_test #{ARGV[1]}`
        parts = output.strip.split
        filename = parts.pop
        action = parts.pop
        name = filename.split('/').last.gsub('_test.rb', '')
        test_name = name.humanize.downcase
        class_name = name.classify.pluralize

        unless action == 'skip'
          # if a new test file was created, we want to modify the default content.
          File.open(filename, 'w+') do |file|
            file.write <<-RUBY
require "application_system_test_case"

class #{class_name}Test < ApplicationSystemTestCase
  test "#{test_name}" do
    write_test_interactively
  end
end
RUBY
          end
        end

        # TODO make this configurable for other editors.
        `atom #{Rails.root.join(filename).to_s}`

        exec "rails test:system #{filename}"
      end
    end
  end
end
