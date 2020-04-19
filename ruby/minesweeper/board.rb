require_relative "tile"

class Board

    OFFSETS = [
    [-1, -1],
    [-1,  0],
    [-1,  1],
    [ 0, -1],
    [ 0,  1],
    [ 1, -1],
    [ 1,  0],
    [ 1,  1]]

    def initialize(size, num_bombs)
        @size = size
        @num_bombs = num_bombs

        @grid = Array.new(size) {Array.new(size,0)}
        place_bombs

        @grid.map! do |row| 
            row.map! {|val| Tile.new(val)}
        end

        inform
        @lost = false
    end

    def game_over?
        self.won? || self.lost?
    end

    def won?
        @grid.all? {|row| row.all?(&:complete?)}
    end

    def lost?
        @lost 
    end

    def [](pos)
        row,col = pos 
        @grid[row][col]
    end

    def []=(pos,value)
        row,col = pos 
        @grid[row][col] = value 
    end

    def reveal(pos)
        self[pos].reveal
        if self[pos].bomb? 
            @lost = true 
        else
            reveal_neighbors(pos)
        end
    end

    def flag(pos)
        self[pos].flag 
    end

    def render(reveal_all = false)
        reveal_bombs if reveal_all
        system("clear")
        puts "  #{(0...@size).to_a.join(' ')}"
        display = generate_display
        display.each_with_index do |row, idx|
            puts "#{idx} #{row.join(' ')}"
        end
    end

    def on_board?(pos)
        row,col = pos
        row.between?(0,@size-1) && col.between?(0,@size-1)
    end

    def revealed?(pos)
        self[pos].revealed?
    end

    private

    attr_reader :grid, :size, :num_bombs

    def inform
        grid.each_with_index do |row, row_idx|
            row.each_with_index do |tile, col_idx|
                pos = [row_idx, col_idx]
                tile.inform_bombs(adjacent_bombs(pos))
                tile.inform_pos(pos)
            end
        end
    end

    def place_bombs
        while num_placed_bombs < num_bombs
            pos = [rand(0...size), rand(0...size)]
            self[pos] = 1
        end
    end

    def num_placed_bombs
        grid.flatten.count {|el| el == 1}
    end

    def generate_display
        grid.map do |row|
            row.map do |tile|
                tile.display
            end
        end
    end

    def neighbs(pos)
        neighbors = []
        row, col = pos
        OFFSETS.each do |offset|
            row_off, col_off = offset 
            new_row = row + row_off
            new_col = col + col_off 
            new_pos = [new_row,new_col]
            neighbors << self[new_pos] if on_board?(new_pos)
        end
        neighbors
    end

    def adjacent_bombs(pos)
        neighbors = neighbs(pos)
        neighbors.count {|neighb| neighb.bomb?}
    end

    def reveal_neighbors(pos)
        neighbors = neighbs(pos)
        neighbors.each do |neighbor|
            unless neighbor.bomb? || neighbor.revealed?
                neighbor.reveal
                reveal_neighbors(neighbor.pos) unless neighbor.adjacent_bombs?
            end
        end
    end

    def reveal_bombs
        grid.each do |row|
            row.each do |tile|
                if tile.bomb?
                    tile.reveal unless tile.revealed?
                end
            end
        end
    end

end