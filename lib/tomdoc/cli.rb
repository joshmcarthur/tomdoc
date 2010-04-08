require 'optparse'

module TomDoc
  class CLI
    #
    # DSL Magics
    #

    def self.options(&block)
      block ? (@options = block) : @options
    end

    def options
      OptionParser.new do |opts|
        opts.instance_eval(&self.class.options)
      end
    end

    def pp(*args)
      require 'pp'
      super
    end


    #
    # Define Options
    #

    options do
      self.banner = "Usage: tomdoc [options] FILE1 FILE2 ..."

      separator " "
      separator "Options:"

      on "-c", "--colored", "Pass -p, -s, or -t output to Pygments." do
        exec "#{$0} #{ARGV * ' '} | pygmentize -l ruby"
      end

      on "-t", "--tokens FILE", "Parse FILE and print the tokenized form." do
        parser = SourceParser.new.parser
        sexp   = parser.parse(ARGF.read)

        pp SourceParser.new.tokenize(sexp)
      end

      on "-s", "--sexp FILE", "Parse FILE and print the AST's sexps." do
        pp RubyParser.new.parse(ARGF.read).to_a
      end

      on "-w", "--html FILE", "Parse FILE and print the TomDoc as HTML." do
        puts Generators::HTML.generate(ARGF.read)
      end

      separator " "
      separator "Common Options:"

      on "-v", "--version", "Print the version" do |v|
        puts "TomDoc v#{VERSION}"
        exit
      end

      on_tail("-h", "--help", "Show this message") do
        puts self
        exit
      end

      separator ""
    end


    #
    # Actions
    #

    def self.process_files(stream)
      new.process_files(stream)
    end

    def process_files(stream)
      puts TomDoc::Generators::Console.generate(stream.read)
    end

    def self.parse_options(args)
      new.parse_options(args)
    end

    def parse_options(args)
      options.parse!(args)
    end
  end
end


#
# Main
#

# Help is the default.
ARGV << '-h' if ARGV.empty? && $stdin.tty?

# Process options
TomDoc::CLI.parse_options(ARGV) if $stdin.tty?

# Still here - process ARGF
TomDoc::CLI.process_files(ARGF)

