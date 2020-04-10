require_relative "board"

class Sudoku 
    
    def initialize
        @board = Board.new
    end

    def play
        until @board.solved? 
            take_turn
        end
        puts "You solved it!"
        board.render 
        sleep(5)
    end

    private

    attr_reader :board

    def take_turn 
        board.render
        pos = get_pos
        val = get_val
        board.update_tile(pos,val)
    end

    def get_pos
        pos = nil
        until pos && valid_pos?(pos)
            puts "Enter the position of the tile (eg. 0,7)"
            pos = gets.chomp.split(',').map(&:to_i)
        end
        pos 
    end

    def valid_pos?(pos)
        return false unless pos.length == 2
        pos.each {|idx| return false unless idx.between?(0,8)}
        true
    end

    def get_val 
        val = nil
        until val && valid_val?(val)
            puts "Enter the new value of the tile (eg. 1), or 0 to clear tile"
            val = gets.chomp.to_i
        end
        val 
    end
    
    def valid_val?(val) 
        val.between?(0,9) ? true : false
    end

end

if __FILE__ == $PROGRAM_NAME
    sudoku = Sudoku.new 
    sudoku.play
end