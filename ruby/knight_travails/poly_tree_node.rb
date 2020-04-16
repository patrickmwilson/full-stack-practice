module Searchable

    def dfs(target = nil)
        raise "Need valid target" unless target
        
        return self if self.value == target

        children.each do |child|
            match = child.dfs(target)
            return match unless match.nil?
        end

        nil
    end

    def bfs(target = nil)
        raise "Need valid target" unless target

        queue = Array.new 

        queue << self 
        until queue.empty?
            current = queue.shift 
            return current if current.value == target
            queue.concat(current.children) 
        end

        nil 
    end
end

class PolyTreeNode

    include Searchable

    attr_reader :value, :parent

    def initialize(value)
        @value, @parent, @children = value, nil, Array.new
    end

    def children 
        @children.dup 
    end

    def parent=(new_parent)
        return if self.parent == new_parent
        self.parent._children.delete(self) if self.parent
        @parent = new_parent 
        self.parent._children << self if self.parent
    end

    def add_child(child)
        child.parent = self 
    end

    def remove_child(child)
        if child
            raise "Tried to remove node that is not a child" unless self.children.include?(child)
            child.parent = nil
        end
    end

    protected

    def _children
        @children 
    end
end
