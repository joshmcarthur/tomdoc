module TomDoc
  class Parser
    def self.parse(text)
      new.parse(text)
    end

    def initialize
      @parser = RubyParser.new
      @scopes = {}
    end

    def parse(text)
      sexp = @parser.parse(text)

      case sexp[0]
      when :class, :module
        name = sexp[1]
        inner = sexp.last[1]
        instance_methods = detect_instance_methods(inner)
        @scopes[name] = Scope.new(name, instance_methods)
      end

      @scopes
    end

    def detect_instance_methods(sexp)
      imethods = []

      sexp.each do |method|
        next unless method.is_a?(Array) && method[0] == :defn
        next unless tomdoc_method?(method)

        name = method[1]
        args = []

        if method[2].size > 1
          args = method[2][1..-1]
          args.pop if args.last.is_a?(Array)
        end

        imethods << Method.new(name, method.comments, args)
      end

      imethods
    end

    def tomdoc_method?(method)
      !method.comments.empty?
    end
  end
end
