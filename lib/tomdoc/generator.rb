module TomDoc
  class Generator
    def self.process(sexp)
      new(sexp).process
    end

    attr_reader :scopes, :classes
    def initialize(scopes)
      @scopes = scopes
    end

    def process(scopes = @scopes, prefix = nil)
      scopes.each do |name, scope|
        if scope.is_a? Scope
          class_methods(scope, prefix)
          instance_methods(scope, prefix)
        else
          process(scope, "#{name}::")
        end
      end
    end

    def class_methods(scope, prefix = nil)
      scope.class_methods.each do |method|
        print_method(method, "#{prefix}#{scope.name}.")
      end
    end

    def instance_methods(scope, prefix = nil)
      scope.instance_methods.each do |method|
        print_method(method, "#{prefix}#{scope.name}#")
      end
    end

    def print_method(method, prefix = '')
      puts '-' * 80
      signature = "#{prefix}#{method.name}#{args(method)}"

      puts signature.bold, ''
      puts format_comment(method.tomdoc)
    end

    def args(method)
      if method.args.any?
        '(' + method.args.join(', ') + ')'
      else
        ''
      end
    end

    def format_comment(comment)
      # Strip leading comments
      comment.gsub!(/^# ?/, '')

      # Example code
      comment.gsub!(/(\s*Examples\s*(.+?)\s*Returns)/m) do
        $1.sub($2, highlight($2))
      end

      # Param list
      comment.gsub!(/^(\s*(\w+) +- )/) do
        param = $2
        $1.sub(param, param.green)
      end

      # true/false/nil
      comment.gsub!(/(true|false|nil)/, '\1'.magenta)

      # Strings
      comment.gsub!(/('.+?')/, '\1'.yellow)
      comment.gsub!(/(".+?")/, '\1'.yellow)

      # Symbols
      comment.gsub!(/(\s+:\w+)/, '\1'.red)

      # Constants
      comment.gsub!(/(([A-Z]\w+(::)?)+)/) do
        if constant?($1.strip)
          $1.split('::').map { |part| part.cyan }.join('::')
        else
          $1
        end
      end

      comment
    end

    def highlight(text)
      command = "pygmentize -l ruby"
      out = ''
      Open3.popen3(command) do |stdin, stdout, stderr|
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
