class Player

    attr_reader :name, :turns

    def initialize(name)
        @name = name
        @turns = 0
        @last_card = nil
    end

    def guess(last_card)
        @turns += 1 unless last_card.nil?
        get_pos
    end

    def prompt
        puts "#{@name}'s turn!"
        puts ""
        puts "Enter the position of the card you'd like to flip (eg. '2,3')"
    end

    def inform(cards)
    end

    def inform_size(size) 
    end

    def inform_dead_positions(cards)
    end

    private

    attr_reader :last_card

    def get_pos
        prompt
        valid = false
        until valid
            pos = get_input
            valid = true if valid_input?(pos)
        end
        pos
    end

    def get_input
        gets.chomp.split(',').map(&:to_i)
    end

    def valid_input?(input)
        return true if input.length == 2
        puts "Invalid position!"
        sleep(2)
        false
    end

end