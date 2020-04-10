class AIPlayer

    attr_reader :name, :turns

    def initialize(name)
        @name = name
        @turns = 0
        @positions = []
        @known_cards = Hash.new
        @known_matches = Hash.new
        @last_card = nil
    end

    def guess(last_card)
        @last_card = last_card
        update
        pick_card
    end

    def inform(card)
        add_known(card)
    end

    def inform_size(size)
        populate_positions(size)
    end

    def inform_dead_positions(cards)
        cards.each do |card|
            delete_known(card)
        end
    end

    private

    attr_reader :last_card, :last_pos, :positions, :matches, :known_cards, :known_matches

    def pick_card
        if last_card.nil?
            pos = match_from_scratch
        else
            pos = match_last_card
        end
        pos = get_new_pos if pos.nil?
        announce(pos)
        pos
    end

    def delete_known(card)
        face_value,pos = card 
        positions.delete(pos)
        known_cards.delete(face_value)
        known_matches.delete(face_value)
    end

    def add_known(card)
        face_value, pos = card
        return if known_matches.has_key?(face_value)

        if known_cards.has_key?(face_value)
            known_matches[face_value] = pos 
        else   
            known_cards[face_value] = pos 
        end 
    end

    def announce(pos) 
        puts "#{pos}"
        sleep(1)
    end

    def match_from_scratch
        return nil if known_matches.empty?
        return known_matches.values.first
    end

    def match_last_card
        face_value, pos = last_card
        return nil unless known_matches.has_key?(face_value)
        known_cards[face_value] 
    end

    def get_new_pos
        pos = nil
        pos = positions.sample
        until pos
            pos = positions.sample
            if last_card.nil?
                face_value, last_pos = last_card
                pos = nil if known_cards.has_value?(last_pos)
            end
        end
        pos
    end

    def populate_positions(size)
        (0...size).each do |idx1|
            (0...size).each do |idx2|
                positions << [idx1,idx2]
            end
        end
    end

    def update
        @turns += 1
        prompt
    end

    def prompt
        puts "#{@name}'s turn!"
        puts ""
        sleep(1)
    end

end