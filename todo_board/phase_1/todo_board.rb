require_relative "list"

class TodoBoard

    def initialize(label)
        @list = List.new(label)
    end

    def get_command
        puts "-" * 60
        puts "Enter a command with arguments separated by spaces."
        puts "For a list of commands, type 'help'."
        puts ""
        cmd, *args = gets.chomp.split(' ')
        cmd.upcase!

        case cmd
        when 'HELP'
            puts " "
            puts "1. Make a todo with the given information"
            puts "mktodo <title> <deadline> <optional description>"
            puts "2. Raises the todo specified by index up the list amount times."
            puts "up <index> <optional amount>"
            puts "3. Lowers the todo specified by index down the list amount times."
            puts "down <index> <optional amount>"
            puts "4. Swap the position of todos specified by the indices"
            puts "swap <index_1> <index_2>"
            puts "5. Sort the todos by date"
            puts "sort"
            puts "6. Print the todo at the top of the list"
            puts "priority"
            puts "7. Print all todos if no index is provided, or print full information of the todo specified by index"
            puts "print <optional index>"
            puts "8. Quit"
            puts "quit"
        when 'MKTODO'
            @list.add_item(*args)
        when 'UP'
            @list.up(*args.map(&:to_i))
        when 'DOWN'
            @list.down(*args.map(&:to_i))
        when 'SWAP'
            @list.swap(*args.map(&:to_i))
        when 'SORT'
            @list.sort_by_date!
        when 'PRIORITY'
            @list.print_priority
        when 'PRINT'
            if !args.length.between?(0,1)
                puts "Too many indices specified!"
            else
                if args.length == 0
                    @list.print 
                else
                    @list.print_full_item(*args.map(&:to_i))
                end
            end
        when 'QUIT'
            return false 
        else
            puts "Invalid command."
        end
        true
    end

    def run 
        while true 
            return if !self.get_command
        end
    end
end