require "set"

class WordChainer

    ALPHABET = "abcdefghijklmnopqrstuvwxyz"

    attr_reader :dictionary

    def initialize(dictionary_file_name)
        words = File.readlines(dictionary_file_name).map(&:chomp) 
        @dictionary = Set.new(words)
    end

    def run(source, target)
        @current_words, @all_seen_words = [source], {source => nil}
        until @current_words.empty? || @all_seen_words.include?(target)
            self.explore_words
        end
        self.output(target)
    end

    def output(target)
        if @all_seen_words.include?(target)
            path = self.build_path(target)
            path.each do |word|
                puts "#{word}"
            end
        else
            puts "Couldn't find a chain that connects the words!"
        end
    end

    def adjacent_words(word)
        words = []
        (0...word.length).each do |idx|
            ALPHABET.each_char do |char|
                this_word = word.dup
                this_word[idx] = char 

                if @dictionary.include?(this_word) && this_word != word 
                    words << this_word 
                end
            end
        end
        words
    end

    def explore_words
        new_current_words = []

        @current_words.each do |current_word|
            adjacent_words = self.adjacent_words(current_word)
            adjacent_words.each do |adjacent_word|

                unless @all_seen_words.has_key?(adjacent_word)
                    @all_seen_words[adjacent_word] = current_word
                    new_current_words << adjacent_word
                end
            end
        end

        @current_words = new_current_words
    end

    def build_path(target)
        path = [target]
        current = target 
        until current.nil?
            current = @all_seen_words[current]
            path << current unless current.nil?
        end
        path.reverse
    end

end

def start
    ready = false
    until ready
        print "Enter the starting word: "
        source = gets.chomp 
        print "Enter the target word: "
        target = gets.chomp 

        if source.length != target.length 
            puts "The two words must be the same length!"
        else
            ready = true 
        end
    end


    chainer = WordChainer.new("dictionary.txt")
    chainer.run(source,target)
end

if __FILE__ == $PROGRAM_NAME
    start
end