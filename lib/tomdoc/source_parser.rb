module TomDoc
  class SourceParser
    def self.parse(text)
      new.parse(text)
    end

    attr_accessor :parser, :scopes
    def initialize
      @parser = RubyParser.new
      @scopes = {}
    end

    def parse(text)
      sexp = @parser.parse(text)

      scope_query = Q?{
        any(
          s(:class, atom % 'name', _, _),
          s(:module, atom % 'name', _)
        )
      }

      imethod_query = Q?{ s(:defn, atom % 'name', _, _) }
      cmethod_query = Q?{ s(:defs, _, atom % 'name', _, _) }

      (sexp / scope_query).each do |result|
        scopes = result.sexp[1..-1] / scope_query
        next unless scopes.any?

        namespace = result['name']
        @scopes[namespace] ||= {}

        scopes.each do |scope|
          sexp = scope.sexp
          scope = Scope.new(scope['name'])
          scope.instance_methods = build_methods(sexp / imethod_query)
          scope.class_methods    = build_methods(sexp / cmethod_query)

          @scopes[namespace][scope.name] = scope
        end
      end

      @scopes
    end

    def build_methods(methods)
      methods.map do |method|
        tomdoc = TomDoc.new(method.sexp.comments)
        next unless tomdoc.valid?

        Method.new(method['name'], method.sexp.comments, build_args(method))
      end.compact
    end

    def build_args(method)
      args = method.sexp / args_query
      return [] unless args.any?
      args.first.sexp[1..-1].select { |arg| arg.is_a? Symbol }
    end

    def args_query
      Q?{ t(:args) }
    end
  end
end
