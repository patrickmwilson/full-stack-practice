require_relative "tile"

class Board

    def self.shuffle_bombs(size)
        num = size * size
        bombs = [1] * size
        values = [0] * (num-size)
        values = (values+bombs).shuffle 
        values.each_slice(9)
    end

    def initialize(size)
        values = Board.shuffle_bombs(size)
        @grid = Array.new(9) {Array.new(9)}
    end

end