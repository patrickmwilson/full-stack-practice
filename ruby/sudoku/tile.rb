require "colorize"

class Tile 

    attr_reader :given, :value

    def initialize(value)
        @given = true unless value == 0
        @value = value
    end

    def value=(new_value)
        @value = new_value unless given?
    end

    def given?
        @given 
    end

    def display
        @value == 0 ? " " : @value.to_s.colorize(color)
    end

    private

    def color 
        given? ? :red : :light_blue
    end 

end