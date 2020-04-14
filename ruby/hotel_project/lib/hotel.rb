require_relative "room"

class Hotel
    def initialize(name, rooms)
        @name = name
        @rooms = rooms
        @rooms.each {|name, cap| @rooms[name] = Room.new(cap)}
    end

    def name
        @name.split(/ |\_/).map(&:capitalize).join(" ")
    end

    def rooms
        @rooms
    end

    def room_exists?(name)
        @rooms.has_key?(name)
    end

    def check_in(person, room)
        if !self.room_exists?(room)
            p "sorry, room does not exist" 
        else
            if @rooms[room].add_occupant(person)
                p "check in successful"
                true
            else
                p "sorry, room is full"
                false
            end
        end
    end

    def has_vacancy?
        @rooms.values.any? {|room| !room.full? }
    end

    def list_rooms
        @rooms.each do |name, room|
            puts "#{name} : #{room.available_space}"
        end
    end

end
