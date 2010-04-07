module TomDoc
  # A Method can be instance or class level.
  class Method
    attr_accessor :name, :tomdoc, :args
    def initialize(name, tomdoc = '', args = [])
      @name   = name
      @tomdoc = tomdoc
      @args   = args
    end
    alias_method :to_s, :name
  end
end
