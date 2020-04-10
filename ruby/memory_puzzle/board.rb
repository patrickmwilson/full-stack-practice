require_relative "card"

class Board

    ALPHABET = ("A".."Z").to_a

    attr_reader :size

    def initialize(size)
        @size = size
        @grid = Array.new(size) {Array.new(size,[])}
        populate
    end

    def [](pos) 
        row,col = pos 
        @grid[row][col]
    end

    def []=(pos,value)
        row,col = pos 
        @grid[row][col] = value
    end

    def render
        system("clear")
        puts "  #{(0...@size).to_a.join(' ')}"
        display = generate_display
        display.each_with_index do |row, idx|
            puts "#{idx} #{row.join(' ')}"
        end
    end

    def won?
        @grid.all? {|row| row.all?(&:face_up?)}
    end

    def reveal(pos)
        unless on_board?(pos)
            puts "Position not on board!"
            return  
        end
        card = self[pos]

        if card.face_up?
            puts "You can't pick a card that's already face up!"
            return 
        end

        card.reveal 
    end

    def hide(pos)
        self[pos].hide 
    end

    private

    attr_reader :grid

    def on_board?(pos)
        row,col = pos
        row.between?(0,@size-1) && col.between?(0,@size-1)
    end

    def populate
        pairs = select_cards
        (0...@size).each do |row|
            (0...@size).each do |col|
                pos = [row, col]
                self[pos] = Card.new(pairs.shift)
            end
        end
    end

    def generate_display
        grid.map do |row|
            row.map do |card|
                card.display
            end
        end
    end

    def select_cards
        num_pairs = (@size*@size)/2
        possible = ALPHABET

        while possible.length < num_pairs
            possible += possible 
        end

        possible.shuffle.take(num_pairs) * 2
    end

end