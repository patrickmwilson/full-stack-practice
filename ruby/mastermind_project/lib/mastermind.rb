require_relative "code"

class Mastermind

    def initialize(length)
        @secret_code = Code.random(length)
    end

    def print_matches(code_instance)
        puts @secret_code.num_exact_matches(code_instance)
        puts @secret_code.num_near_matches(code_instance)
    end

    def ask_user_for_guess
        p "Enter a code"
        guess = Code.from_string(gets.chomp)
        self.print_matches(guess)
        guess == @secret_code
    end


end
