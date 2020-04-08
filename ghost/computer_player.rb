class ComputerPlayer

    ALPHABET = "abcdefghijklmnopqrstuvwxyz"

    attr_reader :name, :score

    def initialize(name)
        @name = name 
        @score = 0
    end

    def guess
        puts "#{@name}'s turn!"
        puts ""
        sleep(2)
        ALPHABET[rand(ALPHABET.length)]
    end

    def alert_invalid_guess 
    end

    def record_loss
        @score += 1
    end

    def out?
        @score == 5
    end

    def announce_out 
        puts "#{@name} is out!"
    end
end