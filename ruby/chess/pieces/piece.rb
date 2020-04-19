class Piece

    attr_reader :color, :board
    attr_accessor :pos

    def initialize(color, pos, board)
        @color = color
        @pos = pos
        @board = board
    end

    def to_s
        " #{symbol} "
    end

end