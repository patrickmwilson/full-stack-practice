require_relative "piece"
require_relative "stepable"

class Knight < Piece 
    include Stepable 

    def symbol 
        '♞'.colorize(color)
    end

    protected

    def offsets
        [
            [2,-1],
            [2,1],
            [-1,2],
            [1,2],
            [-2,1],
            [-2,-1],
            [-1,-2],
            [1,2]
        ]
    end
end