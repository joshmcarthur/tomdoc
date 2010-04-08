module TomDoc
  class SourceParser
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

    # Resets the state of the parser to a pristine one.
    #
    # Returns nothing.
    def reset
      initialize
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
      process(tokenize(sexp))
      @scopes
    end

    def process(ast, scope = nil)
      case ast[0]
      when :module, :class
        name = ast[1]
        new_scope = Scope.new(name)

        if scope
          scope.scopes[name] = new_scope
        else
          @scopes[name] = new_scope
        end

        process(ast[2], new_scope)
      when :imethod
        ast.shift
        scope.instance_methods << Method.new(*ast) if TomDoc.valid?(ast[2])
      when :cmethod
        ast.shift
        scope.class_methods << Method.new(*ast) if TomDoc.valid?(ast[2])
      when Array
        ast.map { |a| process(a, scope) }
      end
    end

    # Converts a Ruby AST-style Sexp into an Array of more useful tokens.
    #
    # node - A Ruby AST Sexp or Array
    #
    # Examples
    #
    #   [:module, :Math,
    #     [:class, :Multiplexer,
    #       [:cmethod,
    #         :multiplex, [:text], "# Class Method Comment"],
    #       [:imethod,
    #         :multiplex, [:text, :count], "# Instance Method Comment"]]]
    #
    # Returns an Array in the above format.
    def tokenize(node)
      case Array(node)[0]
      when :module
        name = node[1]
        [ :module, name, tokenize(node[2]) ]
      when :class
        name = node[1]
        [ :class, name, tokenize(node[3]) ]
      when :defn
        name = node[1]
        args = args_for_node(node[2])
        [ :imethod, name, args, node.comments ]
      when :defs
        name = node[2]
        args = args_for_node(node[3])
        [ :cmethod, name, args, node.comments ]
      when :block
        tokenize(node[1..-1])
      when :scope
        tokenize(node[1])
      when Array
        node.map { |n| tokenize(n) }.compact
      end
    end

    # Given a method sexp, returns an array of the args.
    def args_for_node(node)
      Array(node)[1..-1].select { |arg| arg.is_a? Symbol }
    end
  end
end
