class Queue

    def initialize
        @arr = Array.new
    end

    def enqueue(el)
        arr << el
    end

    def dequeue
        arr.shift
    end

    def peek
        arr.first
    end

    private

    attr_reader :arr
end