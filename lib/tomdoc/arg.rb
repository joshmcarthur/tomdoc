module TomDoc
  class Arg
    attr_accessor :name, :description

    def initialize(name, description = '')
      @name = name
      @description = description
    end

    def optional?
      @description.downcase.include? 'optional'
    end
  end
end
