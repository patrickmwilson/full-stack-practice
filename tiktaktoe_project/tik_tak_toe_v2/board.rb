class Board

    def initialize(n)
        @grid = Array.new(n) {Array.new(n, '_')}
    end

    def [](pos)
        @grid[pos[0]][pos[1]]
    end

    def []=(pos,mark)
        @grid[pos[0]][pos[1]] = mark
    end

    def valid?(pos)
        pos.all? {|el| el.between?(0,(@grid.length-1))}
    end

    def empty?(pos)
        self[pos] == '_'
    end

    def place_mark(pos,mark)
        raise "Out of board bounds" if !self.valid?(pos)
        raise "Position is not empty" if !self.empty?(pos)
        self[pos] = mark
    end

    def print
        @grid.each {|row| puts row.join(" ")}
    end

    def win_row?(mark)
        @grid.any? {|row| row.all? {|pos| pos == mark}}
    end

    def win_col?(mark)
        (0...@grid.length).any? {|idx| @grid.all? {|row| row[idx] == mark}}
    end

    def win_diagonal?(mark)
        right = (0...@grid.length).all? {|idx| @grid[idx][idx] == mark}
        left = (0...@grid.length).all? {|idx| @grid[idx][(@grid.length-1)-idx] == mark}
        right || left
    end

    def win?(mark)
        win_row?(mark) || win_col?(mark) || win_diagonal?(mark)
    end

    def empty_positions?
        @grid.any? {|row| row.include?('_')}
    end


end