require_relative "board"
require_relative "player"

class Game

    def initialize(board_size, players)
        @players = players.map do |mark, is_cpu| 
            is_cpu ? ComputerPlayer.new(mark) : Player.new(mark)
        end
        @current_player = @players[0]
        @board = Board.new(board_size)
    end

    def switch_turn
        @players.rotate!
        @current_player = @players[0]
    end

    def play
        while @board.empty_positions?
            @board.print if @current_player.is_a?(Player)
            @board.place_mark(@current_player.get_position(@board.legal_positions), @current_player.mark)
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