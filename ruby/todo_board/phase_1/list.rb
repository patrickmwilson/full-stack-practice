require_relative "item"

class List

    LINE_WIDTH = 42
    INDEX_COL_WIDTH = 5
    ITEM_COL_WIDTH = 20
    DEADLINE_COL_WIDTH = 10
    TITLE_ROW_WIDTH = 16

    attr_reader :label

    def initialize(label)
        @label = label
        @items = []
    end

    def label=(new_label)
        @label = new_label
    end

    def add_item(title,deadline,description="")
        return false if !Item.valid_date?(deadline)
        @items << Item.new(title,deadline,description)
        true
    end

    def size
        @items.length
    end

    def valid_index?(index)
        index.between?(0,self.size-1)
    end

    def swap(index_1,index_2)
        return false if !self.valid_index?(index_1) || !self.valid_index?(index_2)
        @items[index_1], @items[index_2] = @items[index_2], @items[index_1]
        true
    end

    def [](index)
        return nil if !self.valid_index?(index)
        @items[index]
    end

    def priority
        @items.first
    end

    def print
        puts "-" * LINE_WIDTH
        puts " " * TITLE_ROW_WIDTH + self.label.upcase
        puts "-" * LINE_WIDTH
        puts "#{'Index'.ljust(INDEX_COL_WIDTH)} | #{'Item'.ljust(ITEM_COL_WIDTH)} | #{"Deadline".ljust(DEADLINE_COL_WIDTH)}"
        puts "-" * LINE_WIDTH
        @items.each_with_index do |item,idx|
            puts "#{idx.to_s.ljust(INDEX_COL_WIDTH)} | #{item.title.ljust(ITEM_COL_WIDTH)} | #{item.deadline.ljust(DEADLINE_COL_WIDTH)}"
        end
        puts "-" * LINE_WIDTH
    end

    def print_full_item(index)
        return if !self.valid_index?(index)
        p "-"*LINE_WIDTH
        p "#{@items[index].title.ljust(LINE_WIDTH)} 
            #{@items[index].deadline.rjust(LINE_WIDTH)}"
        p "#{@items[index].description.ljust(LINE_WIDTH)}"
        p "-"*LINE_WIDTH
    end

    def print_priority
        raise "No items in list" if !self.valid_index?(0)
        p "-"*LINE_WIDTH
        p "#{self.priority.title.ljust(LINE_WIDTH)} 
            #{self.priority.deadline.rjust(LINE_WIDTH)}"
        p "#{self.priority.description.ljust(LINE_WIDTH)}"
        p "-"*LINE_WIDTH
    end

    def up(index,amount=1)
        return false if !self.valid_index?(index)
        amount.times do 
            return if index == 0
            @items[index], @items[index-1] = @items[index-1], @items[index]
            index -= 1
        end
    end 

    def down(index,amount=1)
        return false if !self.valid_index?(index)
        amount.times do 
            return if index == @items.length-1
            @items[index], @items[index+1] = @items[index+1], @items[index]
            index += 1
        end
    end

    def sort_by_date!
        @items.sort_by! {|item| item.deadline}
    end
end




