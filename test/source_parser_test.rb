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

  test "attaches TomDoc" do
    m = @chimney.instance_methods.detect { |m| m.name == :get_user_route }
    assert_equal [:user], m.tomdoc.args.map { |a| a.name }
  end

  test "ignores invalid TomDoc'd methods" do
    inames = @chimney.instance_methods.map { |m| m.name }
    cnames = @chimney.class_methods.map { |m| m.name }

    assert !inames.include?(:smoke)
    assert !cnames.include?(:storage_server_disruption)

    # Sanity check
    assert inames.include?(:get_user_route)
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

  test "finds single class in one file" do
    @parser.reset
    result = @parser.parse(fixture(:simple))

    assert result[:Simple]

    methods = result[:Simple].instance_methods
    assert_equal 1, methods.size
    assert_equal [:string], methods.map { |m| m.name }
  end

  test "finds single module in one file"
  test "finds module in a module"
  test "finds module in a class"
  test "finds class in a class"

  test "finds class in a module in a module" do
    @parser.reset
    result = @parser.parse(fixture(:multiplex))

    pp result
    klass = result[:TomDoc][:Fixtures][:Multiple]
    assert klass
    asser_equal 2, klass.instance_methods.size
  end
end
