require_relative "passenger"

class Flight

    attr_reader :passengers

    def initialize(flight_number, capacity)
        @flight_number = flight_number
        @capacity = capacity
        @passengers = []
    end

    def full?
        @capacity <= @passengers.length
    end

    def board_passenger(passenger)
        if !self.full? && passenger.has_flight?(@flight_number)
            @passengers << passenger
        end
    end

    def list_passengers
        output = []
        @passengers.each {|passenger| output << passenger.name}
        output
    end

    def [](index)
        @passengers[index]
    end

    def <<(passenger)
        self.board_passenger(passenger)
    end
end