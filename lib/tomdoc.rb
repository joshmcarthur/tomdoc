require 'pp'

require 'ruby_parser'
require 'colored'

module TomDoc
  autoload :Open3,        'open3'
  autoload :TomDoc,       'tomdoc/tomdoc'
  autoload :Method,       'tomdoc/method'
  autoload :Arg,          'tomdoc/arg'
  autoload :Scope,        'tomdoc/scope'
  autoload :SourceParser, 'tomdoc/source_parser'
  autoload :Generator,    'tomdoc/generator'

  module Generators
    autoload :Console, 'tomdoc/generators/console'
    autoload :HTML,    'tomdoc/generators/html'
  end

  def self.generate(text)
    Generator.process(Parser.parse(text))
  end
end
