require 'test/unit'

require 'tomdoc'

module TomDoc
  class Test < Test::Unit::TestCase
    def self.test(name, &block)
      define_method("test_#{name.gsub(/\W/,'_')}", &block) if block
    end

    def default_test
    end
  end
end
