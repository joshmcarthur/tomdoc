module TomDoc
  class TomDoc
    attr_accessor :raw, :tomdoc
    def initialize(text)
      @raw = text
    end

    def to_s
      tomdoc
    end

    def tomdoc
      raw
    end
  end
end
