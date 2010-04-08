module TomDoc
  class Arg
    attr_accessor :name, :description

    def initialize(name, description = '')
      @name = name.to_s.intern
      @description = description
    end

    def optional?
      @description.downcase.include? 'optional'
    end
  end
end
