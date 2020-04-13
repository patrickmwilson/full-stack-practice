
def range(first,last)
    return [last] if first == last
    [first] + range(first+1,last)
end

def sum_arr(arr)
    return arr.first if arr.length == 1
    arr.shift + sum_arr(arr)
end

def exponent(b, n)
    return 1 if n == 0
    b * exponent_one(b,n-1)
end

def deep_dup(arr)
    new_arr = []
    arr.each do |el|
        if el.is_a?(Array)
            new_arr << deep_dup(el)
        else 
            new_arr << el 
        end
    end
    new_arr
end

def iter_fib(n)
    arr = [] 
    (1..n).each do |i|
        if i == 1 || i == 2
            arr << i 
        else
            arr << (arr[i-2]+arr[i-3])
        end
    end
    arr
end

def fib(n)
    if n <= 2
        [0,1].take(n)
    else
        arr = fib(n-1)
        arr << (arr[-1]+arr[-2])
    end
end

def binary_search(arr,target)
    return nil if arr.empty?
    idx = arr.length/2

    case target <=> arr[idx]
    when -1 
        binary_search(arr.take(idx),target)
    when 0
        idx 
    when 1 
        sub_idx = binary_search(arr.drop(idx+1),target)
        sub_idx.nil? ? nil : (idx+1) + sub_idx 
    end
end

def merge_arr(arr_1, arr_2)
    sorted = []
    until arr_1.empty? || arr_2.empty? 
        if arr_1.first < arr_2.first
            sorted << arr_1.shift 
        else
            sorted << arr_2.shift 
        end 
    end
    sorted + arr_1 + arr_2
end

def merge_sort(arr)
    first = arr[0...(arr.length)/2]
    last = arr[(arr.length)/2..-1]

    if first.length <= 1 && last.length <= 1
        merge_arr(first,last)
    else
        merge_arr(merge_sort(first),merge_sort(last))
    end
end


def subsets(arr)
    return [[]] if arr.empty?
    subs = subsets(arr[0...-1])
    subs + subs.map{|set| set + [arr.last]}
end

def permutations(arr)
    return [arr] if arr.length <= 1
    first = arr.shift 
    perms = permutations(arr)
    output = []

    perms.each do |perm|
        (0..perm.length).each do |idx|
            output << (perm[0...idx] + [first] + perm[idx..-1])
        end
    end
    output
end

def greedy_make_change(amt, coins)
    return [] if amt == 0
    coins.each do |coin|
        if coin <= amt 
            return [coin] + greedy_make_change(amt-coin,coins)
        end
    end
end

def make_change(amt, coins)
    return [] if amt == 0
    return nil if coins.none?{|coin| coin <= amt}

    coins = coins.sort.reverse

    change = nil

    coins.each_with_index do |coin,idx|
        next if coin > amt
        
        greedy_change = make_change(amt-coin,coins)
        smart_change = make_change(amt-coin,coins.drop(idx+1))

        next if smart_change.nil? && greedy_change.nil?

        if smart_change.nil? 
            this_change = [coin] + greedy_change
        else
            this_change = [coin] + smart_change
        end

        if change.nil? || change.length > this_change.length 
            change = this_change
        end
    end
    change
end


