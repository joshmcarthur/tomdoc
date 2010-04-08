require 'test/helper'

class SourceParserTest < TomDoc::Test
  def setup
    @chimney = File.read("test/fixtures/chimney.rb")
    @parser = TomDoc::SourceParser.new
    @result = @parser.parse(@chimney)

    @chimney = @result[:GitHub][:Chimney]
  end

  test "finds instance methods" do
    assert_equal 27, @chimney.instance_methods.size
  end

  test "finds class methods" do
    assert_equal 9, @chimney.class_methods.size
  end

  test "finds namespaces" do
    assert @result[:GitHub][:Math]
  end

  test "finds multiple classes in one file" do
    assert_equal 1, @result[:GitHub][:Math].instance_methods.size
  end

  test "finds single class in one file"
  test "finds single module in one file"
  test "finds module in a module"
  test "finds module in a class"
  test "finds class in a class"

  test "finds class in a module in a module" do
    parser = TomDoc::SourceParser.new
    result = parser.parse(File.read('test/fixtures/multiplex.rb'))

    pp result
    klass = result[:TomDoc][:Fixtures][:Multiple]
    assert klass
    asser_equal 2, klass.instance_methods.size
  end
end
