class Map

    def initialize
        @arr = Array.new
    end

    def set(key, val)
        idx = key_idx(key)
        pair = [key, val]
        if idx.nil?
            arr << pair 
        else 
            arr[idx] = pair
        end
    end

    def get(key)
        idx = key_idx(key)
        return nil if idx.nil?
        arr[idx][1]
    end

    def delete(key)
        idx = key_idx(key)
        arr.delete_at(idx) unless idx.nil?
    end

    def show
        arr
    end

    private

    attr_reader :arr

    def key_idx(key)
        arr.each_with_index do |pair, idx|
            return idx if pair.first == key 
        end
        nil
    end

end