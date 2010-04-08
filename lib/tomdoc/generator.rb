module TomDoc
  class Generator
    attr_reader :scopes

    def initialize(options = {}, scopes = {})
      @options = options
      @scopes  = scopes
      @buffer  = ''
    end

    def self.generate(text_or_sexp)
      new.generate(text_or_sexp)
    end

    def generate(text_or_sexp)
      if text_or_sexp.is_a?(String)
        sexp = SourceParser.parse(text_or_sexp)
      else
        sexp = text_or_sexp
      end

      process(sexp)
    end

    def process(scopes = @scopes, prefix = nil)
      scopes.each do |name, scope|
        write_scope(scope, prefix)
        process(scope, "#{name}::")
      end

      @buffer
    end

    def write_scope(scope, prefix)
      write_scope_header(scope, prefix)
      write_class_methods(scope, prefix)
      write_instance_methods(scope, prefix)
      write_scope_footer(scope, prefix)
    end

    def write_scope_header(scope, prefix)
    end

    def write_scope_footer(scope, prefix)
    end

    def write_class_methods(scope, prefix = nil)
      scope.class_methods.map do |method|
        write_method(method, "#{prefix}#{scope.name}.")
      end
    end

    def write_instance_methods(scope, prefix = nil)
      scope.instance_methods.map do |method|
        write_method(method, "#{prefix}#{scope.name}#")
      end
    end

    def write_method(method, prefix = '')
    end

    def write(*things)
      things.each do |thing|
        @buffer << "#{thing}\n"
      end

      nil
    end

    def pygments(text, *args)
      out = ''

      Open3.popen3("pygmentize", *args) do |stdin, stdout, stderr|
        stdin.puts text
        stdin.close
        out = stdout.read.chomp
      end

      out
    end

    def constant?(const)
      const = const.split('::').first if const.include?('::')
      Object.const_defined?(const) || @scopes[const.to_sym]
    end
  end
end
