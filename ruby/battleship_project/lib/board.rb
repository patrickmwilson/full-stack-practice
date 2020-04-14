class Board

    attr_reader :size

    def initialize(n)
        @grid = Array.new(n) {Array.new(n, :N)}
        @size = n*n
    end

    def [](pos)
        @grid[pos[0]][pos[1]]
    end

    def []=(pos,val)
        @grid[pos[0]][pos[1]] = val
    end

    def num_ships
        @grid.flatten.count {|el| el == :S}
    end

    def attack(pos)
        if self[pos] == :S
            self[pos] = :H 
            p "you sunk my battleship!"
            true
        else
            self[pos] = :X
            false
        end
    end

    def place_random_ships
        while self.num_ships < 0.25*@size
            pos = [rand(0...@grid.length), rand(0...@grid.length)]
            self[pos] = :S
        end
    end

    def hidden_ships_grid
        @grid.map do |row|
            row.map do |el|
                if el == :S 
                    :N
                else
                    el
                end
            end
        end
    end

    def self.print_grid(grid)
        grid.each do |row|
            puts row.join(" ")
        end
    end

    def cheat
        Board.print_grid(@grid)
    end

    def print
        Board.print_grid(self.hidden_ships_grid)
    end

end
