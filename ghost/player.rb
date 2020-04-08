class Player

    attr_reader :name, :score

    def initialize(name)
        @name = name 
        @score = 0
    end

    def guess
        puts "#{@name}'s turn!"
        puts ""
        print "Enter a letter to add to the fragment: "
        gets.chomp.downcase 
    end

    def alert_invalid_guess 
        puts "Invalid guess, try again!"
        puts "Guesses must be a part of the alphabet."
        puts "A word in the dictionary must begin with the new fragment."
        sleep(2)
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