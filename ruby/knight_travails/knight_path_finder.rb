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
        @path = []
    end

    def find_path(end_pos)
        target = root_node.bfs(end_pos)
        trace_back_path(target)
    end

    private

    attr_reader :root_node, :considered_positions, :root_node, :path

    def trace_back_path(node)
        path = []

        current_node = node
        done = false
        until done
            path << current_node.value
            current_node = current_node.parent
            done = true if current_node.parent.nil?
        end
        path << current_node.value

        path.reverse
    end

    def build_move_tree(root)
        nodes = [root]
        until nodes.empty?
            node = nodes.shift 
            new_move_positions(node.value).each do |pos|
                new_node = PolyTreeNode.new(pos)
                new_node.parent = node 
                nodes << new_node
            end
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