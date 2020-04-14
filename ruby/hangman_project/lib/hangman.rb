class Hangman
  DICTIONARY = ["cat", "dog", "bootcamp", "pizza"]

  def self.random_word 
    DICTIONARY.sample
  end

  def initialize
    @secret_word = Hangman.random_word
    @guess_word = Array.new(@secret_word.length, "_")
    @attempted_chars = Array.new
    @remaining_incorrect_guesses = 5
  end

  def guess_word
    @guess_word
  end

  def attempted_chars
    @attempted_chars
  end

  def remaining_incorrect_guesses
    @remaining_incorrect_guesses
  end

  def already_attempted?(char)
    @attempted_chars.include?(char)
  end

  def get_matching_indices(char)
    idxs = []
    word = @secret_word.split("")
    word.each_with_index {|ch, idx| idxs << idx if ch == char}
    idxs
  end

  def fill_indices(char, arr)
    arr.each {|idx| @guess_word[idx] = char}
  end

  def try_guess(char)
    if self.already_attempted?(char)
      p "that has already been attempted"
      return false
    else
      @attempted_chars << char
      idxs = self.get_matching_indices(char)
      @remaining_incorrect_guesses -= 1 if idxs.empty?
      self.fill_indices(char, idxs)
    end
    true
  end

  def ask_user_for_guess
    p "Enter a char:"
    char = gets.chomp
    self.try_guess(char)
  end

  def win?
    if @guess_word == @secret_word.split("")
      p "WIN"
      true
    else
      false
    end
  end

  def lose?
    if @remaining_incorrect_guesses == 0
      p "LOSE"
      true
    else
      false
    end
  end

  def game_over?
    if self.win? || self.lose?
      p @secret_word
      true
    else
      false
    end
  end
end
