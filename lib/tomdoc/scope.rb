module TomDoc
  # A Scope is a Module or Class.
  # It may contain other scopes.
  class Scope
    attr_accessor :name, :scopes, :instance_methods, :class_methods
    def initialize(name, instance_methods = [], class_methods = [])
      @name = name
      @scopes = {}
      @instance_methods = instance_methods
      @class_methods = class_methods
    end
    alias_method :to_s, :name

    def [](scope)
      @scopes[scope]
    end

    def keys
      @scopes.keys
    end

    def inspect
      scopes = @scopes.keys.join(', ')
      imethods = @instance_methods.inspect
      cmethods = @class_methods.inspect

      "<#{name} scopes:[#{scopes}] :#{cmethods}: ##{imethods}#>"
    end
  end
end
