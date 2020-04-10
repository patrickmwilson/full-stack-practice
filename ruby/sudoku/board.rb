require_relative "tile"

class Board

    def self.from_file 
        tiles = File.readlines("sudoku1.txt").map(&:chomp) 
        tiles.map {|row| row.split(//)}
    end

    def initialize
        @grid = Board.from_file.map do |row|
            row.map! do |value|
                Tile.new(value.to_i)
            end
        end
    end

    def [](pos)
        row,col = pos 
        @grid[row][col]
    end

    def update_tile(pos, value)
        tile = self[pos]
        if tile.given?
            puts "You can't change a given tile!"
            return false
        else 
            tile.value = value 
            return true 
        end
    end

    def solved?
        rows.all? { |row| solved_set?(row) } &&
        columns.all? { |col| solved_set?(col) } &&
        squares.all? { |square| solved_set?(square) }
    end

    def render
        system("clear")
        puts "  #{(0..8).to_a.join(' ')}"
        display = generate_display
        display.each_with_index do |row, idx|
            puts "#{idx} #{row.join(' ')}"
        end
    end

    private 

    attr_reader :grid 

    def generate_display
        grid.map do |row|
            row.map do |tile|
                tile.display
            end
        end
    end

    def solved_set?(tiles)
        vals = tiles.map(&:value)
        (0..9).all? {|i| vals.include?(i)}
    end

    def rows
        grid 
    end

    def cols 
        rows.transpose
    end

    def square(idx)
        tiles = []
        x = (idx / 3) * 3
        y = (idx % 3) * 3

        (x...x + 3).each do |i|
            (y...y + 3).each do |j|
                tiles << self[[i, j]]
            end
        end

        tiles
    end

  def squares
    (0..8).to_a.map { |i| square(i) }
  end


end