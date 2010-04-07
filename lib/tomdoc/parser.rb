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
        name    = sexp[1]
        inner   = sexp.last[1]

        @scopes[name] = build_scope(name, inner)
      end

      @scopes
    end

    def build_scope(name, sexp)
      if sexp[0] == :class || sexp[0] == :module
        name  = sexp[1]
        inner = sexp.last[1]
        scopes = {}
      elsif sexp[0] == :block
        inner = sexp[1..-1]
      else
        puts "I don't understand: "
        pp sexp
        exit 1
      end

      scope = Scope.new(name)
      scope.instance_methods = detect_instance_methods(inner)
      scope.class_methods    = detect_class_methods(inner)

      if scopes
        scopes[name] = scope
        scopes
      else
        scope
      end
    end

    def detect_instance_methods(sexp)
      detect_methods(:defn, sexp)
    end

    def detect_class_methods(sexp)
      detect_methods(:defs, sexp)
    end

    def detect_methods(type, sexp)
      methods = []

      sexp.each do |method|
        next unless method.is_a?(Array) && type == method[0]
        next unless tomdoc_method?(method)

        # Hack for static methods - second arg is their scope
        method.delete_at(1) if type == :defs

        name = method[1]
        args = []

        if method[2].size > 1
          args = method[2][1..-1]
          args.pop if args.last.is_a?(Array)
        end

        methods << Method.new(name, method.comments, args)
      end

      methods
    end

    def tomdoc_method?(method)
      !method.comments.empty?
    end
  end
end
