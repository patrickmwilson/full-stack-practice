class Card 

    attr_reader :face_value

    def initialize(face_value,status=false)
        @face_value = face_value
        @status = status
    end

    def display
        self.face_up? ? @face_value : " "
    end

    def hide 
        @status = false
    end

    def reveal
        @status = true 
        @face_value
    end

    def face_up?
        @status
    end

end