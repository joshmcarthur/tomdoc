module TomDoc
  module Generators
    class HTML < Generator
      def highlight(text)
        pygments(text, '-l', 'ruby', '-f', 'html')
      end

      def write_scope_header(scope, prefix)
      end

      def write_scope_footer(scope, prefix)
      end

      def write_class_methods(scope, prefix)
        out = '<ul>'
        out << super.to_s
        puts out
      end

      def write_instance_methods(scope, prefix)
        out = ''
        out << super.to_s
        out << '</ul>'
        puts out
      end

      def write_method(method, prefix = '')
        if method.args.any?
          args = '(' + method.args.join(', ') + ')'
        end
        out = '<li>'
        out << "<b>#{prefix}#{method.to_s}#{args}</b>"

        out << '<pre>'
        out << method.tomdoc.to_s
        out << '</pre>'

        out << '</li>'
      end
    end
  end
end
