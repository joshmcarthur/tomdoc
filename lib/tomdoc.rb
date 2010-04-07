require 'open3'
require 'pp'

require 'ruby_parser'
require 'colored'

require 'tomdoc/method'
require 'tomdoc/scope'
require 'tomdoc/parser'

require 'tomdoc/generator'

module TomDoc
  def self.generate(text)
    Generator.process(Parser.parse(text))
  end
end
