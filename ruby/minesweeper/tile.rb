require "colorize"

class Tile

    attr_reader :pos

    def initialize(value)
        @value = value
        @status = false
        @flagged = false
        @adjacent_bombs = 0
        @pos = nil
    end

    def reveal
        if revealed?
            puts "That tile has already been revealed!"
            return 
        end
        @status = true
        unflag if flagged?
    end

    def complete?
        return true if revealed?
    end

    def revealed?
        @status 
    end

    def adjacent_bombs?
        @adjacent_bombs > 0
    end

    def flag
        if revealed?
            puts "That tile has already been revealed!"
            sleep(2)
        elsif flagged?
            puts "That tile has already been flagged!"
            sleep(2)
        else
            @flagged = true
        end
    end

    def flagged?
        @flagged 
    end

    def unflag
        @flagged = false 
    end

    def bomb?
        @value == 1
    end

    def inform_bombs(adjacent)
        @adjacent_bombs = adjacent
    end

    def inform_pos(pos)
        @pos = pos 
    end

    def display
        to_s.colorize(color)
    end

    private

    attr_reader :adjacent_bombs

    def to_s
        return 'F' if flagged?
        return '*' unless revealed?
        return '*' if bomb?
        adjacent_bombs? ? @adjacent_bombs.to_s : ' '
    end

    def color 
        return :green if flagged?
        return :white unless revealed?
        return :red if bomb?
        case @adjacent_bombs
        when 1
            :blue
        when 2
            :green
        else
            :yellow
        end
    end
end