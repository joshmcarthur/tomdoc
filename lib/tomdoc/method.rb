module TomDoc
  # A Method can be instance or class level.
  class Method
    attr_accessor :name, :args
    def initialize(name, tomdoc = '', args = [])
      @name   = name
      @tomdoc = tomdoc
      @args   = args
    end

    def to_s
      name
    end

    def tomdoc
      TomDoc.new(@tomdoc)
    end
  end
end
