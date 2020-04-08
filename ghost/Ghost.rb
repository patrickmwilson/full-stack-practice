require "set"
require_relative "player"
require_relative "computer_player"

class Game

    ALPHABET = "abcdefghijklmnopqrstuvwxyz"
    GHOST = "GHOST"
    LINE_WIDTH = 33


    def initialize(player_names)
        words = File.readlines("dictionary.txt").map(&:chomp) 
        @dictionary = Set.new(words)

        @players = []
        player_names.each do |name, computer|
            if computer 
                @players << ComputerPlayer.new(name)
            else
                @players << Player.new(name)
            end
        end

        @fragment = ""
    end

    def run 
        self.play_round until self.game_over?
        puts "#{self.active_players.first.name} wins!"
    end

    def play_round
        self.reset_fragment
        
        self.display_score

        while !self.round_over?
            self.take_turn
            self.next_player!
        end

        self.end_round 
    end

    def take_turn
        valid = false 
        while !valid 
            valid = true
            system("clear")
            puts "The current fragment is: '#{@fragment}'"
            puts ""
            letter = self.current_player.guess
            if !self.valid_play?(letter)
                valid = false 
                self.current_player.alert_invalid_guess
            end
        end
        self.update_fragment(letter)
        puts "#{@fragment}"
        system("clear")
    end

    #Helper functions

    def game_over?
        self.active_players.length == 1
    end

    def round_over?
        @dictionary.include?(@fragment)
    end

    def end_round
        puts "Round over!"
        puts "#{self.previous_player.name} spelled '#{@fragment}'!"
        sleep(2)

        self.previous_player.record_loss

        if self.previous_player.out?
            self.previous_player.announce_out
        end
    end

    #Return all players still in game
    def active_players
        @players.select {|player| !player.out?} 
    end

    #Return current player
    def current_player
        @players.first
    end

    #Returns last active player after rotation
    def previous_player
        self.active_players.last
    end

    #Select next player
    def next_player!
        active_player_found = false 
        while !active_player_found
            @players.rotate!
            active_player_found = true if !self.current_player.out?
        end
    end

    #Determines if the guess letter is in the alphabet and the new fragment is a possible word start
    def valid_play?(letter)
        return false if !ALPHABET.include?(letter)
        @dictionary.any? {|word| word.start_with?(@fragment + letter)}
    end

    #Adds a valid guess to the current fragment
    def update_fragment(letter)
        @fragment += letter
    end

    def reset_fragment 
        @fragment = ""
    end

    #Displays each player's score
    def display_score
        puts "-" * LINE_WIDTH
        puts " " * 8 + "CURRENT STANDINGS"
        puts "-" * LINE_WIDTH

        @players.each do |player| 
            string_score = "" + GHOST[0...player.score]
            puts "#{player.name}: #{string_score}".ljust(LINE_WIDTH)
        end

        puts "-" * LINE_WIDTH
        sleep(2)
        system("clear")
    end

end

def start_game 
    player_names = Hash.new()
    ready = false 
    while !ready

        system("clear")
        puts ""
        puts "Let's play a game of Ghost!"
        puts ""

        if !player_names.empty? 
            puts "Current players:"
            puts ""
            player_names.keys.each {|name| puts "#{name}"}
            puts ""
        end

        puts "Enter a name, or the number of AI players!"
        puts ""
        print "Enter name, number, or leave blank to begin: "
        input = gets.chomp 

        if !input.empty? 
            if input.to_i == 0
                player_names[input] = false
            else
                (input.to_i).times do |i|
                    name = "Computer_" + i.to_s
                    player_names[name] = true
                end
            end
        else  
            human_players = player_names.values.count {|v| !v}
            if human_players < 1
                puts ""
                puts "You can't play Ghost without a human player!"
                sleep(2)
            else
                ready = true 
            end
        end
    end

    new_game = Game.new(player_names)
    new_game.run

end

start_game