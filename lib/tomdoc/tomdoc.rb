module TomDoc
  class InvalidTomDoc < RuntimeError
    def initialize(doc)
      @doc = doc
    end

    def message
      @doc
    end

    def to_s
      @doc
    end
  end

  class TomDoc
    attr_accessor :raw

    def initialize(text)
      @raw = text
    end

    def to_s
      tomdoc
    end

    def valid?
      tomdoc
      true
    rescue InvalidTomDoc
      false
    end

    def tomdoc
      if !raw.include?('Returns')
        raise InvalidTomDoc.new("No `Returns' statement.")
      end

      raw.split("\n").map do |line|
        line =~ /^(\s*# ?)/ ? line.sub($1, '') : nil
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
        lines = $1.split("\n")
        statements = []

        lines.each do |line|
          if line =~ /^\s+/
            statements.last << line.squeeze(' ')
          else
            statements << line
          end
        end

        statements
      else
        []
      end
    end
  end
end
