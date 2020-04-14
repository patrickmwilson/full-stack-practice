class Player

    def get_move
        p "enter a position with coordinates separated with a space like `4 7`"
        gets.chomp.split(" ").map {|el| el.to_i}
    end


end
