require_relative "piece"

class Pawn < Piece 

    def initialize(color, pos, board=nil)
        super(color, pos, board)
        @start_row = (color == :white ? 1 : 6)
        @forward_dir = (color == :white ? 1 : -1)
    end

    def symbol
        '♟'.colorize(color)
    end

    def moves
        forward_moves + side_attacks
    end

    def forward_moves
        row, col = pos

        first = [row+@forward_dir, col]

        return [] unless board.valid_pos?(first) && board.empty?(first)

        moves = [first]

        if at_start_row?
            second = [(row+(@forward_dir*2)), col]
            moves << second if board.valid_pos?(second) && board.empty?(second)
        end
        moves
    end

    def side_attacks
        moves = []
        row, col = pos 

        first = [row+@forward_dir, col+1]

        if board.valid_pos?(first) && enemy_piece?(first)
            moves << first 
        end

        second = [row+@forward_dir, col-1]
        if board.valid_pos?(second) && enemy_piece?(second)
            moves << second
        end
        moves
    end

    def enemy_piece?(pos)
        enemy_color = (color == :white ? :black : :white)
        board[pos].color == enemy_color 
    end

    def at_start_row?
        row,col = pos 
        row == @start_row
    end  
end