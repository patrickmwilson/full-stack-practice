module Stepable

    def moves
        moves = []

        offsets.each do |offset|
            row, col = pos 
            drow, dcol = offset

            new_pos = [(row+drow),(col+dcol)]

            next unless board.valid_pos?(new_pos)
            if board.empty?(new_pos) || enemy_piece?(new_pos)
                moves << new_pos 
            end
        end
        moves
    end

    def enemy_piece?(curr_pos)
        enemy_color = (color == :white ? :black : :white)
        board[curr_pos].color == enemy_color 
    end
end