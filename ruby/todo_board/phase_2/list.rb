require_relative "item"

class List

    LINE_WIDTH = 55
    INDEX_COL_WIDTH = 5
    STATUS_COL_WIDTH = 4
    ITEM_COL_WIDTH = 20
    DEADLINE_COL_WIDTH = 10
    TITLE_ROW_WIDTH = 18
    CHECKMARK = "\u2713".force_encoding('utf-8')

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

        puts "#{'Index'.ljust(INDEX_COL_WIDTH)} | #{'Item'.ljust(ITEM_COL_WIDTH)} | #{"Deadline".ljust(DEADLINE_COL_WIDTH)} | [Status]"

        puts "-" * LINE_WIDTH

        @items.each_with_index do |item,idx|
            status = item.done ? CHECKMARK : ' '
            puts "#{idx.to_s.ljust(INDEX_COL_WIDTH)} | #{item.title.ljust(ITEM_COL_WIDTH)} | #{item.deadline.ljust(DEADLINE_COL_WIDTH)} | [#{status}]"
        end

        puts "-" * LINE_WIDTH
    end

    def print_full_item(index)
        return if !self.valid_index?(index)
        status = @items[index].done ? CHECKMARK : ' '
        puts "-" * LINE_WIDTH
        puts "#{@items[index].title}".ljust(LINE_WIDTH) + "#{@items[index].deadline} [#{status}]".rjust(LINE_WIDTH/2)
        puts @items[index].description
        puts "-" * LINE_WIDTH
    end

    def print_priority
        raise "No items in list" if !self.valid_index?(0)
        self.print_full_item(0)
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

    def toggle_item(index)
        raise "Invalid index" if !self.valid_index?(index)
        @items[index].toggle 
    end

    def remove_item(index)
        return false if !self.valid_index?(index)
        @items.delete_at(index)
        true 
    end

    def purge
        purged = false 
        while !purged 
            purged = true
            @items.each_with_index do |item,idx| 
                if item.done
                    self.remove_item(idx) 
                    purged = false 
                end 
            end 
        end
    end

end




