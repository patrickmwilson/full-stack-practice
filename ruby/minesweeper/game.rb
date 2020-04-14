require_relative "board"

class Game

    def initialize(size, num_bombs)
        @board = Board.new(size, num_bombs)
    end

    def play
        until @board.game_over?
            take_turn
        end
        board.render(true)
        if board.won?
            puts "You win!"
        else
            puts "You lost!"
        end
        sleep(5)
    end

    private

    attr_reader :board

    def take_turn 
        pos = get_pos
        val = get_move
        make_move(pos, val)
    end

    def make_move(pos, val)
        case val 
        when 'r'
            board.reveal(pos)
        when 'f'
            board.flag(pos)
        end
    end

    def get_move
        val = nil
        until valid_move?(val)
            board.render
            print "Enter 'f' to flag the tile or 'r' to reveal the tile: "
            val = gets.chomp.downcase
        end
        val
    end

    def valid_move?(val)
        unless val == 'r' || val == 'f'
            puts "Enter 'f' or 'r'!"
            sleep(2)
            return false 
        end
        true
    end

    def get_pos
        pos = nil
        until valid_pos?(pos)
            board.render
            print "Enter the position of the tile (eg. 3,2): "
            pos = gets.chomp.split(",").map(&:to_i)
        end
        pos
    end

    def valid_pos?(pos)
        return false if pos.nil?
        unless pos.length == 2
            puts "Position must be two numbers (eg. 3,2)!"
            sleep(2)
            return false
        end
        unless board.on_board?(pos)
            puts "Position not on board!"
            sleep(2)
            return false 
        end
        if board.revealed?(pos)
            puts "Tile already revealed!"
            sleep(2)
            return false 
        end
        true
    end

end

def valid_size?(size)
    return false unless size.is_a?(Integer)
    return false unless size.between?(0,3)
    true
end

def get_input
    size = nil 
    while size.nil? || !valid_size?(size)
        puts "Enter 1 for small (9x9), 2 for medium (16x16), 3 for large (32x32)."
        size = gets.chomp.to_i
    end
    size
end

def start_game
    size = get_input
    case size 
    when 1
        board_size = 9
        num_bombs = 10
    when 2
        board_size = 16
        num_bombs = 40 
    when 3
        board_size = 32
        num_bombs = 160
    end

    game = Game.new(board_size, num_bombs)
    game.play 
end

if __FILE__ == $PROGRAM_NAME
    start_game
end