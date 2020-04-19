module Slideable
    HORIZONTAL_VERTICAL_DIRS = [
        [1,0],
        [-1,0],
        [0,1],
        [0,-1]
    ]

    DIAGONAL_DIRS = [
        [1,1],
        [1,-1],
        [-1,1],
        [-1,-1]
    ]

    def horizontal_vertical_dirs 
        HORIZONTAL_VERTICAL_DIRS 
    end

    def diagonal_dirs 
        DIAGONAL_DIRS
    end

    def moves
        moves = []
        move_dirs.each do |dir|
            moves.concat(slide(dir))
        end
        moves
    end

    def slide(dir)
        moves = []

        new_pos = pos.dup
        loop do 
            new_pos = get_new_pos(new_pos, dir)

            break unless board.valid_pos?(new_pos)

            if board.empty?(new_pos) || enemy_piece?(new_pos) 
                moves << new_pos
            end
            break unless board.empty?(new_pos)
        end
        moves
    end

    def get_new_pos(curr_pos, dir)
        row, col = curr_pos
        drow, dcol = dir 
        [(row+drow),(col+dcol)]
    end

    def enemy_piece?(curr_pos)
        enemy_color = (color == :white ? :black : :white)
        board[curr_pos].color == enemy_color
    end

end