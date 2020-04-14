class Code
  POSSIBLE_PEGS = {
    "R" => :red,
    "G" => :green,
    "B" => :blue,
    "Y" => :yellow
  }

  attr_reader :pegs

  def self.valid_pegs?(arr)
    arr.all? {|char| Code::POSSIBLE_PEGS.include?(char.upcase)}
  end

  def self.random(length)
    Code.new(Array.new(length) {Code::POSSIBLE_PEGS.keys.sample})
  end

  def initialize(arr)
    raise if !Code.valid_pegs?(arr)
    @pegs = arr.map(&:upcase)
  end

  def self.from_string(str)
    Code.new(str.split(""))
  end

  def [](idx)
    @pegs[idx]
  end

  def length
    @pegs.length
  end

  def num_exact_matches(guess)
    (0...guess.length).count {|idx| guess[idx] == @pegs[idx]}
  end

  def num_near_matches(guess)
    (0...guess.length).count {|idx| @pegs.include?(guess[idx]) && @pegs[idx] != guess[idx]}
  end

  def ==(other_code)
    other_code.pegs == @pegs
  end
  
end
