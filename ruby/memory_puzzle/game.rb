require_relative "board"
require_relative "player"
require_relative "ai_player"

class Game

    def initialize(size,player_names)
        @board = Board.new(size)

        @players = []
        player_names.each do |name, ai|
            if ai
                @players << AIPlayer.new(name)
            else
                @players << Player.new(name)
            end
        end
    end

    def play
        inform_size
        until @board.won?
            take_turn
        end
        puts "#{last_player.name} won in #{last_player.turns} turns!"
    end

    private

    attr_reader :players, :board

    def take_turn
        first_card = make_guess(nil)
        inform(first_card)
        second_card = make_guess(first_card)
        inform(second_card)

        if fvalue(first_card) != fvalue(second_card)
            sleep(2)
            hide([first_card,second_card])
        else
            inform_dead_positions(first_card)
            inform_dead_positions(second_card)
        end
        next_player!
    end

    def fvalue(card)
        card[0]
    end

    def hide(cards)
        cards.each do |card|
            pos = card[1]
            board.hide(pos)
        end
    end

    def reveal(pos)
        board.reveal(pos)
    end

    def make_guess(last_card)
        face_value = nil
        until face_value
            board.render

            pos = current_player.guess(last_card)

            face_value = reveal(pos)

            board.render 
        end

        [face_value,pos]
    end

    def inform(card)
        players.each {|player| player.inform(card)}
    end

    def inform_size 
        players.each {|player| player.inform_size(board.size)}
    end

    def inform_dead_positions(card)
        players.each {|player| player.inform_dead_positions(card)}
    end

    def next_player!
        players.rotate!
    end

    def current_player
        players.first
    end

    def last_player
        players.last
    end

end

def prompt_input(player_names)
    system("clear")
    puts ""
    puts "Let's play a Memory Puzzle!"
    puts ""
    unless player_names.empty?
        puts "Current players:"
        puts ""
        player_names.keys.each {|name| puts "#{name}"}
        puts ""
    end
    puts "Enter a name, or the number of AI players!"
    puts ""
    print "Enter name, number, or leave blank to begin: "
end

def get_board_size
    system("clear")
    puts ""
    print "Enter the board size: "
    size = nil 
    until size
        size = gets.chomp.to_i 
        if size.odd?
            puts "Board size must be an even number"
            size = nil 
        end 
    end 
    size
end

def add_players(input)
    player_names = Hash.new
    add_ai = input.to_i != 0
    if add_ai
        (input.to_i).times do |i|
            name = "AIPlayer_" + i.to_s
            player_names[name] = true
        end
    else
        player_names[input] = false
    end
    player_names
end

def ready?(player_names)
    return true if player_names.values.count {|v| !v} > 0
    puts "Need one human player!" 
    sleep(2)
    false
end

def start_game
    player_names = Hash.new()
    start = false
    until start
        prompt_input(player_names)
        input = gets.chomp 

        if input.empty?
            start = ready?(player_names)
        else
            player_names = (add_players(input)).merge(player_names)
        end
        
    end
    size = get_board_size

    game = Game.new(size,player_names)
    game.play

end

if __FILE__ == $PROGRAM_NAME
    start_game
end