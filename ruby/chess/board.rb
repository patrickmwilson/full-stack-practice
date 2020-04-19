require_relative "pieces"

class Board

    COLORS = [:white, :white, nil, nil, nil, nil, :black, :black]

    SETUP = [
        ["R","K","B","KI","Q","B","K","R"],
        ["P","P","P","P","P","P","P","P"],
        ["N","N","N","N","N","N","N","N"],
        ["N","N","N","N","N","N","N","N"],
        ["N","N","N","N","N","N","N","N"],
        ["N","N","N","N","N","N","N","N"],
        ["P","P","P","P","P","P","P","P"],
        ["R","K","B","Q","KI","B","K","R"],
    ]

    def initialize
        @sentinel = NullPiece.instance
        @grid = new_board
    end

    def [](pos)
        row, col = pos 
        @grid[row][col]
    end

    def []=(pos, value)
        row,col = pos 
        @grid[row][col] = value
    end

    def empty?(pos)
        self[pos].is_a?(NullPiece)
    end

    def move_piece(player_color, start_pos, end_pos)
        raise "There's no piece to move at that position!" if self.empty?(start_pos)
        piece = self[start_pos]
        raise "You must move your own piece" unless piece.color == player_color
        raise "That piece can't move there!" unless piece.moves.include?(end_pos)
        self[end_pos] = piece
        self[start_pos] = sentinel
        piece.pos = end_pos
    end

    def valid_pos?(pos)
        row,col = pos 
        row.between?(0,7) && col.between?(0,7)
    end

    private

    attr_reader :sentinel, :grid

    def new_board
        grid = []

        (0..7).each do |row_idx|
            row = []
            (0..7).each do |col_idx|
                color = COLORS[row_idx]
                symbol = SETUP[row_idx][col_idx]
                pos = [row_idx,col_idx]
        
                case symbol 
                when "KI"
                    tile = King.new(color,pos,self)
                when "Q"
                    tile = Queen.new(color,pos,self)
                when "B"
                    tile = Bishop.new(color,pos,self)
                when "K"
                    tile = Knight.new(color,pos,self)
                when "R"
                    tile = Rook.new(color,pos,self)
                when "P"
                    tile = Pawn.new(color,pos,self)
                else
                    tile = sentinel
                end

                row << tile 
            end
            grid << row 
        end
        grid 
    end

end
