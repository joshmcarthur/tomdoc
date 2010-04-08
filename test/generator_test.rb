require 'test/helper'

class GeneratorTest < TomDoc::Test
  def setup
    @class = Class.new(TomDoc::Generator) do
      def write_method(method, prefix = '')
        @buffer = [] if @buffer.is_a?(String)
        @buffer << method.name
      end
    end

    @generator = @class.new
  end

  test "can ignore validation methods" do
    @generator.options[:validate] = false
    methods = @generator.generate(fixture(:chimney))
    assert_equal 46, methods.size
  end

  test "ignores invalid methods" do
    @generator.options[:validate] = true
    methods = @generator.generate(fixture(:chimney))
    assert_equal 38, methods.size
  end
end
