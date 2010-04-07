module TomDoc
  class Generator
    def self.process(sexp)
      new(sexp).process
    end

    attr_reader :scopes, :classes
    def initialize(scopes)
      @scopes = scopes
    end

    def process
      @scopes.each do |name, scope|
        scope.instance_methods.each do |method|
          puts '-' * 80
          signature = "#{name}##{method.name}"

          if method.args.any?
            signature << '('
            signature << method.args.join(', ')
            signature << ')'
          end

          puts signature.bold, ''
          puts format_comment(method.tomdoc)
        end
      end
    end

    def format_comment(comment)
      comment.gsub!(/^# ?/, '')

      comment.gsub!(/^(\s*(\w+) +- )/) do
        param = $2
        $1.sub(param, param.green)
      end

      comment.gsub!(/(true|false|nil)/, '\1'.magenta)

      comment.gsub!(/(\s+:\w+)/, '\1'.red)

      comment.gsub!(/(([A-Z]\w+(::)?)+)/) do
        if constant?($1.strip)
          $1.split('::').map { |part| part.cyan }.join('::')
        else
          $1
        end
      end

      comment.gsub!(/(\s*Examples\s*(.+?)\s*Returns)/m) do
        $1.sub($2, highlight($2))
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
