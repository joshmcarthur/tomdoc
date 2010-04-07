module TomDoc
  # A Scope is a Module or Class.
  class Scope
    attr_accessor :name, :instance_methods, :class_methods
    def initialize(name, instance_methods = [], class_methods = [])
      @name = name
      @instance_methods = instance_methods
      @class_methods = class_methods
    end
    alias_method :to_s, :name
  end
end
