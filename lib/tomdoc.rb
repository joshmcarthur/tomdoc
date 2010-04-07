require 'pp'
require 'open3'

require 'ruby_parser'
require 'colored'

require 'tomdoc/parser'
require 'tomdoc/generator'

require 'tomdoc/generators/html'
require 'tomdoc/generators/console'

module TomDoc
  def self.generate(text)
    Generator.process(Parser.parse(text))
  end
end
