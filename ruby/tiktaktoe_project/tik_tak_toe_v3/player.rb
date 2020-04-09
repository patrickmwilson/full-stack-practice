class Player

    attr_reader :mark

    def initialize(mark)
        @mark = mark
    end

    def get_position(legal_positions)
        legal = false
        while !legal
            p "Enter a position as 'row col' #{@mark.to_s}"
            pos = gets.chomp.split(" ").map(&:to_i)
            p "Invalid position" if pos.length != 2
            legal = true if legal_positions.include?(pos)
        end
        pos
    end

end