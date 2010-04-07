module TomDoc
  class TomDoc
    attr_accessor :raw

    def initialize(text)
      @raw = text
    end

    def to_s
      tomdoc
    end

    def tomdoc
      raw.split("\n").map do |line|
        line =~ /^(\s*#\s*)/ ? line.sub($1, '') : nil
      end.compact.join("\n")
    end

    def description
      tomdoc.split("\n\n").first
    end

    def args
      tomdoc.split("\n\n")[1].map do |line|
        param, desc = line.split(" - ")
        Arg.new(param.strip, desc.strip) if param && desc
      end.compact
    end

    def examples
      if tomdoc =~ /(\s*Examples\s*(.+?)\s*Returns)/m
        $2.split("\n\n")
      else
        []
      end
    end

    def returns
      if tomdoc =~ /^\s*(Returns.+)/m
        $1.split("\n")
      else
        []
      end
    end
  end
end
