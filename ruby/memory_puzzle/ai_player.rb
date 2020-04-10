class AIPlayer

    attr_reader :name, :turns

    def initialize(name)
        @name = name
        @turns = 0
        @positions = []
        @known_cards = Hash.new
        @matches = []
        @hot_match = nil
        @last_pos = nil
        @last_card = nil
    end

    def guess(last_card)
        @last_card = last_card
        @hot_match = nil if last_card.nil?
        pos = pick_card

        puts "#{@name}'s turn!"
        puts ""
        sleep(1)

        puts "#{pos}"
        sleep(1)

        set_last_pos(pos)
        @turns += 1 unless last_card.nil?

        pos
    end

    def inform(card)
        face_value, pos = card

        if @known_cards.has_key?(face_value)
            @matches << [@known_cards[face_value],pos]
        else
            @known_cards[face_value] = pos
        end
    end

    def inform_size(size)
        (0...size).each do |idx1|
            (0...size).each do |idx2|
                @positions << [idx1,idx2]
            end
        end
    end

    def inform_dead_positions(card)
        face_value, pos = card
        @positions.delete(pos)
    end

    private

    attr_reader :last_card, :last_pos, :positions, :matches, :grid, :known_cards

    def pick_card
        if last_card.nil?
            pos = match_from_scratch
        else
            pos = @hot_match
            pos = match_last_card if pos.nil?
        end
        pos = get_new_pos if pos.nil?
        pos
    end

    def match_from_scratch
        @matches.each do |match|
            first_pos, second_pos = match
            if positions.include?(first_pos)
                @hot_match = second_pos
                return first_pos
            end
        end
        nil
    end

    def match_last_card
        face_value, pos = last_card
        return nil unless known_cards.has_key?(face_value)
        return nil if pos == known_cards[face_value]
        return known_cards[face_value]
    end

    def get_new_pos
        pos = nil
        until pos 
            pos = positions.sample
            if last_card.nil? 
                face_value, last_pos = last_card
                if known_cards.has_value?(pos)
                    pos = nil 
                end
            end
        end
        pos
    end

    def set_last_pos(pos)
        last_card.nil? ? last_pos = pos : last_pos = nil
    end

end