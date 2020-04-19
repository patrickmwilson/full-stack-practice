require_relative "piece"
require "singleton"

class NullPiece < Piece 
    include Singleton

    attr_reader :symbol

    def initialize
        @color = :none
    end

    def symbol
        " "
    end

    def empty?
        true
    end

    def moves
        []
    end

end