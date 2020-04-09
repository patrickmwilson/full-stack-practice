class Item

    def self.valid_date?(date_string)
        date = date_string.split("-")
        year, month, day = date.map(&:to_i)
        return false if date.length != 3 
        return false if !month.between?(0,12) || !day.between?(1,31)
        return true
    end

    attr_reader :title, :deadline, :description

    def initialize(title,deadline,description)
        raise "Invalid date" if !Item.valid_date?(deadline)
        @title = title
        @deadline = deadline
        @description = description
    end

    def title=(new_title)
        @title = new_title
    end

    def deadline=(new_deadline)
        raise "Invalid date" if !Item.valid_date?(new_deadline)
        @deadline = new_deadline 
    end

    def description=(new_description)
        @description = new_description
    end

end