require_relative "board"
require_relative "player"

class Game

    def initialize(player_1_mark, player_2_mark)
        @player_1 = Player.new(player_1_mark)
        @player_2 = Player.new(player_2_mark)
        @board = Board.new
        @current_player = @player_1
    end

    def switch_turn
        if @current_player == @player_1
            @current_player = @player_2
        else
            @current_player = @player_1
        end
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