module TomDoc
  class SourceParser
    # DSL for defining sexp_path queries quickly.
    #
    # name - The Symbol name of the query. Queries can be accessed
    #        using the "name_query" instance method, where name is this
    #        argument.
    # query - The sexp_path query.
    #
    # Returns nothing.
    def self.query(name, query)
      define_method("#{name}_query", proc { query })
    end

    #
    # Sexp Queries
    #

    # See http://github.com/adamsanderson/sexp_path#readme for
    # help in authoring them.
    #
    # Any query, once defined, can be used in the parser by calling
    # "name_query", where name is the first argument to the `query`
    # method.

    query :scope, Q?{
      any(
        s(:class, atom % 'name', _, _),
        s(:module, atom % 'name', _)
      )
    }

    query :args, Q?{ t(:args) }

    query :imethod, Q?{
      s(:defn, atom % 'name', _, _)
    }

    query :cmethod, Q?{
      s(:defs, _, atom % 'name', _, _)
    }

    # Converts Ruby code into a data structure.
    #
    # text - A String of Ruby code.
    #
    # Returns a Hash with each key a namespace and each value another
    #   Hash or a TomDoc::Scope.
    def self.parse(text)
      new.parse(text)
    end

    attr_accessor :parser, :scopes

    # Each instance of SourceParser accumulates scopes with each
    # parse, making it easy to parse an entire project in chunks but
    # more difficult to parse disperate files in one go. Create
    # separate instances for separate global scopes.
    #
    # Returns an instance of TomDoc::SourceParser
    def initialize
      @parser = RubyParser.new
      @scopes = {}
    end

    # Converts Ruby code into a data structure. Note that at the
    # instance level scopes accumulate, which makes it easy to parse
    # multiple files in a single project but harder to parse files
    # that have no connection.
    #
    # text - A String of Ruby code.
    #
    # Examples
    #   @parser = TomDoc::SourceParser.new
    #   files.each do |file|
    #     @parser.parse(File.read(file))
    #   end
    #   pp @parser.scopes
    #
    # Returns a Hash with each key a namespace and each value another
    #   Hash or a TomDoc::Scope.
    def parse(text)
      sexp = @parser.parse(text)

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

    # Helps build Method objects from method definition sexps. Ignores
    # any methods that aren't valid TomDoc - like this one ;)
    def build_methods(methods)
      built = []

      methods.each do |method|
        sexp   = method.sexp
        tomdoc = TomDoc.new(sexp.comments)
        next unless tomdoc.valid?

        built << Method.new(method['name'], tomdoc, build_args(sexp))
      end

      built
    end

    # Given a method definition sexp, returns an array of argument
    # names.
    def build_args(sexp)
      args = sexp / args_query
      return [] unless args.any?
      args.first.sexp[1..-1].select { |arg| arg.is_a? Symbol }
    end
  end
end
