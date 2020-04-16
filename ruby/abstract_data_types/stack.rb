class Stack
    def initialize
      # create ivar to store stack here!
      @arr = Array.new
    end

    def push(el)
      # adds an element to the stack
      arr << el
    end

    def pop
      # removes one element from the stack
      arr.pop
    end

    def peek
      # returns, but doesn't remove, the top element in the stack
      arr.last
    end

    private

    attr_reader :arr 

  end