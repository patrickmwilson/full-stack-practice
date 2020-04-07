require_relative "board"
require_relative "player"

class Game

    def initialize(board_size, *player_marks)
        @board = Board.new(board_size)
        @players = player_marks.map {|mark| Player.new(mark)}
        @current_player = @players[0]
    end

    def switch_turn
        @players.rotate!
        @current_player = @players[0]
    end

    def play
        while @board.empty_positions?
            @board.print
            @board.place_mark(@current_player.get_position, @current_player.mark)
            if @board.win?(@current_player.mark)
                p "#{@current_player.mark.to_s} wins!"
                return
            else
                self.switch_turn
            end
        end
        p "It's a draw!"
    end


end