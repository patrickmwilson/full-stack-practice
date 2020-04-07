
class Player

    attr_reader :mark

    def initialize(mark)
        @mark = mark
    end

    def get_position
        p "Enter a position as 'row col' #{@mark.to_s}"
        pos = gets.chomp.split(" ").map(&:to_i)
        raise "Invalid position" if pos.length != 2
        pos
    end

end