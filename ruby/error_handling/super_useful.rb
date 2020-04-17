# PHASE 2
def convert_to_int(str)
  begin
    num = Integer(str)
  rescue ArgumentError => e  
    puts "Argument error - can't convert to int"
  ensure
    num ||= 0
  end
end

# PHASE 3
FRUITS = ["apple", "banana", "orange"]

class CoffeeError < StandardError
  def message
    "I'll let you try again, but only because you've given me coffee!"
  end
end

class FoodError < StandardError
  def message 
    "I hate that food!"
  end
end

def reaction(maybe_fruit)
  if FRUITS.include? maybe_fruit
    puts "OMG, thanks so much for the #{maybe_fruit}!"
  elsif maybe_fruit == "coffee" 
    raise CoffeeError
  else
    raise FoodError
  end 
end

def feed_me_a_fruit
  puts "Hello, I am a friendly monster. :)"

  begin
    puts "Feed me a fruit! (Enter the name of a fruit:)"
    maybe_fruit = gets.chomp
    reaction(maybe_fruit) 
  rescue CoffeeError => e
    puts "#{e.message}"
    retry
  rescue FoodError => e  
    puts "#{e.message}"
  end
end  

# PHASE 4
class KnowledgeError < ArgumentError
  def message 
    "You don't know anything about me!"
  end
end

class TimeError < ArgumentError
  def message 
    "How can we be best friends when we haven't known each other very long?"
  end
end

class BestFriend
  def initialize(name, yrs_known, fav_pastime)
    raise KnowledgeError if name.empty? || fav_pastime.empty? 
    raise TimeError if yrs_known < 5
    @name = name
    @yrs_known = yrs_known
    @fav_pastime = fav_pastime
  end

  def talk_about_friendship
    puts "Wowza, we've been friends for #{@yrs_known}. Let's be friends for another #{1000 * @yrs_known}."
  end

  def do_friendstuff
    puts "Hey bestie, let's go #{@fav_pastime}. Wait, why don't you choose. 😄"
  end

  def give_friendship_bracelet
    puts "Hey bestie, I made you a friendship bracelet. It says my name, #{@name}, so you never forget me." 
  end
end


