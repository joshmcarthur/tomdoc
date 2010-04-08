require 'test/helper'

class SourceParserTest < TomDoc::Test
  def setup
    @chimney = File.read("test/fixtures/chimney.rb")
    @parser = TomDoc::SourceParser.new
    @result = @parser.parse(@chimney)
  end

  test "parses" do
    pp @result
    assert @result[:GitHub]
    assert @result[:GitHub][:Chimney]
    assert @result[:GitHub][:Math]
  end
end
