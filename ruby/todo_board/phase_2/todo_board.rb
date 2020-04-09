require_relative "list"

class TodoBoard

    def initialize()
        @lists = Hash.new
    end

    def make_list(label)
        @lists[label] = List.new(label)
    end

    def ls
        if @lists.length < 1
            puts "No lists have been created" 
        else
            @lists.each_key {|label| puts label}
        end
    end

    def showall 
        if @lists.length < 1
            puts "No lists have been created" 
        else
            @lists.each_value {|list| list.print}
        end
    end

    def get_command
        puts ""
        puts "-" * 60
        puts "For a list of commands, type 'help'."
        print "Enter a command: "


        cmd, label, *args = gets.chomp.split(' ')
        cmd.upcase!

        case cmd
        when 'HELP'
            puts " "
            puts "1. Create a new list"
            puts "mklist <new_list_label>"
            puts "2. Print the labels of all existing lists"
            puts "ls"
            puts "3. Print all lists"
            puts "showall"
            puts "4. Add a todo to the specified list"
            puts "mktodo <list_label> <item_title> <item_deadline> <optional_item_description>"
            puts "5. Move the specified item higher on the given list."
            puts "up <list_label> <item_index> <optional_amount>"
            puts "6. Move the specified item lower on the given list"
            puts "down <list_label> <item_index> <optional_amount>"
            puts "7. Swap the positions of the specified items on the given list"
            puts "swap <list_label> <item_index_1> <item_index_2>"
            puts "8. Sort the given list by deadline"
            puts "sort <list_label>"
            puts "9. Print all information for the item at the top of the given list"
            puts "priority <list_label>"
            puts "10. Print all todos on the given list if no index is provided, or print full information of the todo specified by index"
            puts "print <list_label> <optional_index>"
            puts "11. Toggle the status of a todo between done/not done"
            puts "toggle <list_label> <item_index>"
            puts "12. Remove the specified item on the given list"
            puts "rm <list_label> <item_index>"
            puts "13. Remove all completed todos from the given list"
            puts "purge <list_label>"
            puts "14. Quit"
            puts "quit"

        when 'MKLIST'
            self.make_list(label)
            
        when 'LS'
            puts ""
            self.ls 

        when 'SHOWALL'
            puts ""
            self.showall
        
        when 'MKTODO'
            @lists[label].add_item(*args)

        when 'UP'
            @lists[label].up(*args.map(&:to_i))

        when 'DOWN'
            @lists[label].down(*args.map(&:to_i))

        when 'SWAP'
            @lists[label].swap(*args.map(&:to_i))

        when 'SORT'
            @lists[label].sort_by_date!

        when 'PRIORITY'
            @lists[label].print_priority

        when 'PRINT'
            if !args.length.between?(0,1)
                puts "Too many indices specified!"
            else
                puts ""
                if args.length == 0
                    @lists[label].print 
                else
                    @lists[label].print_full_item(*args.map(&:to_i))
                end
            end

        when 'TOGGLE'
            if !args.length.between?(0,1)
                puts "Too many indices specified!"
            else
                @lists[label].toggle_item(*args.map(&:to_i))
            end

        when 'RM'
            if !args.length.between?(0,1)
                puts "Too many indices specified!"
            else
                @lists[label].remove_item(*args.map(&:to_i))
            end

        when 'PURGE'
            @lists[label].purge

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

TodoBoard.new.run

