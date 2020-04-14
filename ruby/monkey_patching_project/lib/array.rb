# Monkey-Patch Ruby's existing Array class to add your own custom methods
class Array
    def span
        return nil if self.empty?
        self.max-self.min
    end

    def average
        return nil if self.empty?
        self.sum/self.length.to_f
    end

    def median
        return nil if self.empty?
        self.sort!
        if self.length%2 == 0
            (self[(self.length)/2]+self[((self.length)/2)-1])/2.0
        else 
            self[(self.length)/2]
        end
    end

    def counts
        hash = Hash.new(0)
        self.each {|el| hash[el] += 1}
        hash
    end

    def my_count(val)
        self.counts[val]
    end

    def my_index(val)
        return nil if !self.include?(val)
        self.each_with_index {|el, idx| return idx if el == val}
    end

    def my_uniq
        unique = []
        self.each {|el| unique << el if !unique.include?(el)}
        unique
    end

      def my_transpose
    transposed = []

    self.each_with_index do |ele1, idx1|
      row = []

      self.each_with_index do |ele2, idx2|
        row << self[idx2][idx1]
      end

      transposed << row
    end

    transposed
  end
end
