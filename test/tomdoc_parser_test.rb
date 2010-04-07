require 'test/helper'

class TomDocParserTest < TomDoc::Test
  def setup
    @comment = TomDoc::TomDoc.new(<<comment)
    # Duplicate some text an abitrary number of times.
    #
    # text  - The String to be duplicated.
    # count - The Integer number of times to duplicate the text.
    #
    # Examples
    #   multiplex('Tom', 4)
    #   # => 'TomTomTomTom'
    #
    #   multiplex('Bo', 2)
    #   # => 'BoBo'
    #
    #   multiplex('Chris', -1)
    #   # => nil
    #
    # Returns the duplicated String when the count is > 1.
    # Returns the atomic mass of the element as a Float. The value is in
    #   unified atomic mass units.
    # Returns nil when the count is < 1.
comment

    @comment2 = TomDoc::TomDoc.new(<<comment2)
    # Duplicate some text an abitrary number of times.
    #
    # Returns the duplicated String.
comment2

    @comment3 = TomDoc::TomDoc.new(<<comment3)
    # Duplicate some text an abitrary number of times.
    #
    # Examples
    #
    #   multiplex('Tom', 4)
    #   # => 'TomTomTomTom'
    #
    #   multiplex('Bo', 2)
    #   # => 'BoBo'
comment3
  end

  test "knows when TomDoc is invalid" do
    assert_raises TomDoc::InvalidTomDoc do
      @comment3.examples
    end
  end

  test "parses a description" do
    assert_equal "Duplicate some text an abitrary number of times.",
      @comment.description
  end

  test "parses args" do
    assert_equal 2, @comment.args.size
  end

  test "knows an arg's name" do
    assert_equal 'text', @comment.args.first.name
  end

  test "knows an arg's description" do
    assert_equal 'The Integer number of times to duplicate the text.',
      @comment.args.last.description
  end

  test "knows an arg's optionality" do
    assert_equal true, @comment.args.first.optional?
    assert_equal false, @comment.args.last.optional?
    assert_equal 1, @comment.args.last.default
  end

  test "knows what to do when there are no args" do
    assert_equal 0, @comment2.args.size
  end

  test "knows how many examples there are" do
    assert_equal 3, @comment.examples.size
  end

  test "knows each example" do
    assert_equal "  multiplex('Bo', 2)\n  # => 'BoBo'",
      @comment.examples[1].to_s
  end

  test "knows what to do when there are no examples" do
    assert_equal 0, @comment2.examples.size
  end

  test "knows how many return examples there are" do
    assert_equal 3, @comment.returns.size
  end

  test "knows each return example" do
    assert_equal "Returns the duplicated String when the count is > 1.",
      @comment.returns.first.to_s

    string = ''
    string << "Returns the atomic mass of the element as a Float. "
    string << "The value is in unified atomic mass units."
    assert_equal string, @comment.returns[1].to_s

    assert_equal "Returns nil when the count is < 1.",
      @comment.returns[2].to_s
  end

  test "knows what to do when there are no return examples" do
    assert_equal 0, @comment2.examples.size
  end
end
