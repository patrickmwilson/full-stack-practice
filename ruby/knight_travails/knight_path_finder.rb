require_relative "poly_tree_node"

class KnightPathFinder

    attr_reader :move_tree

    OFFSETS = [
        [2,-1],
        [2,1],
        [-1,2],
        [1,2],
        [-2,1],
        [-2,-1],
        [-1,-2],
        [1,2]
    ]

    def self.valid_moves(pos)
        valid_moves = Array.new 
        x, y = pos
        OFFSETS.each do |(dx, dy)|
            new_pos = [x + dx, y + dy]
            valid = new_pos.all? {|coord| coord.between?(0,7)}
            valid_moves << new_pos if valid
        end
        valid_moves
    end

    def initialize(start_pos)
        @root_node = PolyTreeNode.new(start_pos)
        @considered_positions = []
        @considered_positions << start_pos
        @move_tree = build_move_tree(@root_node)
    end

    private

    attr_reader :root_node, :considered_positions, :root_node

    def build_move_tree(root)
        moves = new_move_positions(root.value)
        moves.each do |pos|
            node = PolyTreeNode.new(pos)
            node.parent = root 
            build_move_tree(node)
        end
    end

    def new_move_positions(pos)
        possible_moves = KnightPathFinder.valid_moves(pos)
        moves = possible_moves.select do |move| 
            !considered_positions.include?(move)
        end
        considered_positions.concat(moves)
        moves
    end
end