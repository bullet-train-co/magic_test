module MagicTest
  module Support
    def assert_selected_exists
      selected_text = page.evaluate_script("window.selectedText()")
      return if selected_text.blank?

      filepath, line = get_last_caller(caller)

      contents = File.open(filepath).read.lines
      chunks = contents.each_slice(line.to_i - 1 + @test_lines_written).to_a
      indentation = chunks[1].first.match(/^(\s*)/)[0]
      chunks.first << indentation + "assert(page.has_content?('#{selected_text.gsub("'", "\\\\'")}'))" + "\n"
      @test_lines_written += 1
      contents = chunks.flatten.join
      File.open(filepath, "w") do |file|
        file.puts(contents)
      end
    end

    def track_keystrokes
      page.evaluate_script("trackKeystrokes()")
    end

    def flush
      filepath, line = get_last_caller(caller)

      contents = File.open(filepath).read.lines
      chunks = contents.each_slice(line.to_i - 1 + @test_lines_written).to_a
      indentation = chunks[1].first.match(/^(\s*)/)[0]
      output = page.evaluate_script("JSON.parse(sessionStorage.getItem('testingOutput'))")
      puts
      puts "javascript recorded on the front-end looks like this:"
      puts output
      puts
      puts "(writing that to `#{filepath}`.)"
      if output
        output.each do |last|
          chunks.first << indentation + "#{last["action"]} #{last["target"]}#{last["options"]}" + "\n"
          @test_lines_written += 1
        end
        contents = chunks.flatten.join
        File.open(filepath, "w") do |file|
          file.puts(contents)
        end
        # clear the testing output now.
        empty_cache
      else
        puts "`window.testingOutput` was empty in the browser. Something must be wrong on the browser side."
      end
      true
    end

    def ok
      filepath, line = get_last_caller(caller)

      puts "(writing that to `#{filepath}`.)"
      contents = File.open(filepath).read.lines
      chunks = contents.each_slice(line.to_i - 1 + @test_lines_written).to_a
      indentation = chunks[1].first.match(/^(\s*)/)[0]
      get_last.each do |last|
        chunks.first << indentation + last + "\n"
        @test_lines_written += 1
      end
      contents = chunks.flatten.join
      File.open(filepath, "w") do |file|
        file.puts(contents)
      end
      true
    end

    def empty_cache
      page.evaluate_script("sessionStorage.setItem('testingOutput', JSON.stringify([]))")
    rescue Capybara::NotSupportedByDriverError => _
      # TODO we need to add more robust instructions for this.
      raise "You need to configure this test (or your test suite) to run in a real browser (Chrome, Firefox, etc.) in order for Magic Test to work. It also needs to run in non-headless mode if `ENV['MAGIC_TEST'].present?`"
    end

    def magic_test
      empty_cache
      @test_lines_written = 0
      begin
        magic_test_pry_hook
        binding.pry
      rescue
        retry
      end
    end

    private

    def magic_test_pry_hook
      Pry.hooks.add_hook(:before_session, "magic_test") do |output, binding, pry|
        Pry.hooks.delete_hook(:before_session, 'magic_test')
        pry.run_command('up')
      end
    end

    def get_last
      history_lines = Readline::HISTORY.to_a.last(20)
      i = 2
      last = history_lines.last(2).first
      last_block = [last]
      if last == "end" || last.first(4) == "end "
        i += 1
        last_block.unshift(history_lines.last(i).first)
        until !last_block.first.match(/^(\s+)/) & [0]
          i += 1
          last_block.unshift(history_lines.last(i).first)
        end
      end

      last_block
    end

    # TODO this feels like it's going to end up burning people who have other support files in `test` or `spec` that don't include `helper` in the name.
    def get_last_caller(caller)
      caller.select { |s| s.include?("/test/") || s.include?("/spec/") }
        .reject { |s| s.include?("helper") }
        .first.split(":").first(2)
    end
  end
end
