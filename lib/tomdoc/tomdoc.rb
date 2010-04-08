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

    def self.valid?(text)
      new(text).valid?
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

      clean = raw.split("\n").map do |line|
        line =~ /^(\s*# ?)/ ? line.sub($1, '') : nil
      end.compact.join("\n")

      if clean.split("\n\n").size < 2
        raise InvalidTomDoc.new("No description section found.")
      end

      clean
    end

    def sections
      tomdoc.split("\n\n")
    end

    def description
      sections.first
    end

    def args
      args = []
      last_indent = nil

      sections[1].split("\n").each do |line|
        next if line.strip.empty?
        indent = line.scan(/^\s*/)[0].to_s.size

        if last_indent && indent > last_indent
          args.last.description += line.squeeze(" ")
        else
          param, desc = line.split(" - ")
          args << Arg.new(param.strip, desc.strip) if param && desc
        end

        last_indent = indent
      end

      args
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
