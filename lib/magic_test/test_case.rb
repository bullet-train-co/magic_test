class ActionDispatch::SystemTestCase

  def assert_selected_exists
    selected_text = page.evaluate_script("window.selectedText()")
    return if selected_text.blank?
    filepath, line = caller.select { |s| s.include?("/test/") }.reject { |s| s.include?("helper") }.first.split(':')
    contents = File.open(filepath).read.lines
    chunks = contents.each_slice(line.to_i - 1 + @test_lines_written).to_a
    indentation = chunks[1].first.match(/^(\s*)/)[0]
    chunks.first << indentation + "assert(page.has_content?('#{selected_text.gsub("'", "\\\\'")}'))" + "\n"
    @test_lines_written += 1
    contents = chunks.flatten.join
    File.open(filepath, 'w') do |file|
      file.puts(contents)
    end
  end

  def track_keystrokes
    page.evaluate_script("trackKeystrokes()")
  end

  def get_last
    history_lines = Readline::HISTORY.to_a.last(20)
    i = 2
    last = history_lines.last(2).first
    last_block = [last]
    if last == 'end' || last.first(4) == 'end '
      i += 1
      last_block.unshift(history_lines.last(i).first)
      until !last_block.first.match(/^(\s+)/)&[0] do
        i += 1
        last_block.unshift(history_lines.last(i).first)
      end
    end
    return last_block
  end

  def flush
    filepath, line = caller.select { |s| s.include?("/test/") }.reject { |s| s.include?("helper") }.first.split(':')
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
        chunks.first << indentation + "#{last['action']} #{last['target']}#{last['options']}" + "\n"
        @test_lines_written += 1
      end
      contents = chunks.flatten.join
      File.open(filepath, 'w') do |file|
        file.puts(contents)
      end
      # clear the testing output now.
      empty_cache
    else
      puts "`window.testingOutput` was empty in the browser. Something must be wrong on the browser side."
    end
    return true
  end

  def ok
    filepath, line = caller.select { |s| s.include?("/test/") }.reject { |s| s.include?("helper") }.first.split(':')
    puts "(writing that to `#{filepath}`.)"
    contents = File.open(filepath).read.lines
    chunks = contents.each_slice(line.to_i - 1 + @test_lines_written).to_a
    indentation = chunks[1].first.match(/^(\s*)/)[0]
    get_last.each do |last|
      chunks.first << indentation + last + "\n"
      @test_lines_written += 1
    end
    contents = chunks.flatten.join
    File.open(filepath, 'w') do |file|
      file.puts(contents)
    end
    return true
  end

  def empty_cache
    page.evaluate_script("sessionStorage.setItem('testingOutput', JSON.stringify([]))")
  end

  def magic_test
    empty_cache
    @test_lines_written = 0
    begin
      binding.pry
    rescue
      retry
    end
  end

end
