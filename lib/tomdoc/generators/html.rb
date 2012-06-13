module TomDoc
  module Generators
    class HTML < Generator

      def highlight(text)
        pygments(text, '-l', 'ruby', '-f', 'html')
      end

      def write_styles
        styles = <<-CSS
        <style type='text/css'>
          body {
            font-family: sans-serif;
            font-size: 14px;
            margin: 5% 10%;
          }

          h1 {
            font-size: 24px;

          }

          ul, li {
            list-style: none;
            margin: 0;
            padding: 0;
          }

          ul > li > b {
            display: block;
            font-size: 18px;
            line-height: 27px;
            padding-bottom: 5px;
            margin-bottom: 18px;
            border-bottom: 1px solid #EEE;
          }

          pre {
            display: block;
            padding: 8.5px;
            margin: 0 0 9px;
            font-size: 14px;
            font-family: sans-serif;
            line-height: 18px;
            word-break: break-all;
            word-wrap: break-word;
            white-space: pre;
            white-space: pre-wrap;
          }

          #method_navigation {
            position: absolute;
            right: 0px;
            top: 0px;
            display: block;
            padding: 8.5px;
            background: whiteSmoke;
           }
         </style>
         CSS

         write styles
      end

      def write_page_header
        write_styles
      end

      def write_page_footer
        write_method_navigation
      end


      def write_method_navigation
        out = "<dl id='method_navigation'>"
        @methods.each do |prefix, methods|
          out << "<dt>#{prefix.to_s[0..-2]}</dt>"
          out << "<dd><ul>"
          methods.uniq.each do |method_name|
            out << "<li><a href='##{prefix}#{method_name}'>#{method_name}</a></li>"
          end

          out << "</ul></dd>"
        end
        out << "</dl>"

        write out
      end

      def write_scope_header(scope, prefix)
        #write "<h1>#{scope.name}</h1>"
      end

      def write_scope_footer(scope, prefix)
      end

      def write_class_methods(scope, prefix)
        out = '<ul>'
        out << super.join
        write out
      end

      def write_instance_methods(scope, prefix)
        out = ''
        out << super.join
        out << '</ul>'
        write out
      end

      def write_method(method, prefix = '')
        @methods ||= {}
        @methods[prefix] ||= []
        @methods[prefix] << method.to_s

        if method.args.any?
          args = '(' + method.args.join(', ') + ')'
        end
        out = '<li>'

        out << <<-METHOD_HEAD
          <b id="#{prefix.to_s}#{method.to_s}">
            #{prefix.to_s}#{method.to_s}#{args.to_s}
          </b>
        METHOD_HEAD

        out << '<pre>'
        out << method.tomdoc.tomdoc
        out << '</pre>'

        out << '</li>'
      end
    end
  end
end
