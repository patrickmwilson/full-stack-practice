class Array

    def my_each(&prc)
        output = []
        self.length.times do |idx|
            output << prc.call(self[idx])
        end
        output
    end

    def my_select(&prc) 
        output = []
        self.length.times do |idx| 
            output << self[idx] if prc.call(self[idx])
        end
        output 
    end

    def my_reject(&prc) 
        output = [] 
        self.length.times do |idx| 
            output << self[idx] if !prc.call(self[idx]) 
        end 
        output 
    end 

    def my_any?(&prc) 
        self.length.times do |idx| 
            return true if prc.call(self[idx]) 
        end 
        false 
    end

    def my_all?(&prc) 
        self.length.times do |idx| 
            return false if !prc.call(self[idx]) 
        end 
        true
    end

    def my_flatten
        output = [] 
        self.each do |el| 
            if el.is_a?(Array)
                output += el.my_flatten
            else
                output << el 
            end
        end
        output
    end

    def my_zip(*args) 
        output = []
        self.each_with_index do |el, idx|
            out = []
            out << el
            args.each do |arg|
                if idx < arg.length 
                    out << arg[idx]
                else
                    out << nil 
                end 
            end
            output << out 
        end 
        output 
    end
    
    def my_rotate(n=1)
        while n != 0
            if n > 0
                self << self.shift
                n -= 1
            else 
                self.unshift(self.pop)
                n += 1 
            end 
        end 
    end

    def my_join(separator = "")
        output = ""
        self.each.each_with_index do |el,idx|
            output << el 
            output << separator if idx != self.length-1
        end 
        output 
    end 

    def my_reverse
        output = [] 
        (1..self.length).each do |idx|
            output << self[-idx] 
        end 
        output 
    end
end

