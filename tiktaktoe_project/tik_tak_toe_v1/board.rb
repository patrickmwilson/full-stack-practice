class Board

    def initialize
        @grid = Array.new(3) {Array.new(3, '_')}
    end

    def valid?(position)
        position[0].between?(0,3) && position[1].between?(0,3)
    end

    def empty?(position)
        @grid[position[0]][position[1]] == '_'
    end

    def place_mark(position,mark)
        raise "Invalid position" if !self.valid?(position)
        raise "Position is not empty" if !self.empty?(position)
        @grid[position[0]][position[1]] = mark
    end

    def print
        @grid.each {|row| puts row.join(" ")}
    end

    def win_row?(mark)
        @grid.any? do |row| 
            return true if row.all? {|pos| pos == mark}
        end
        false
    end

    def win_col?(mark)
        (0...3).any? do |idx|
            @grid.all? {|row| row[idx] == mark}
        end
    end

    def win_diagonal?(mark)
        right = (0..2).all? {|idx| @grid[idx][idx] == mark}
        left = (0..2).all? {|idx| @grid[idx][2-idx] == mark}
        right || left
    end

    def win?(mark)
        win_row?(mark) || win_col?(mark) || win_diagonal?(mark)
    end

    def empty_positions?
        @grid.any? {|row| row.include?('_')}
    end


end