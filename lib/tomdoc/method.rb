module TomDoc
  # A Method can be instance or class level.
  class Method
    attr_accessor :name, :args
    def initialize(name, comment = '', args = [])
      @name    = name
      @comment = comment
      @args    = args
    end

    def to_s
      name
    end

    def tomdoc
      @tomdoc ||= TomDoc.new(@comment)
    end

    def inspect
      "#{name}(#{args.join(', ')})"
    end
  end
end
