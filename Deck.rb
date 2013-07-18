
class Deck
  
  def initialize
    @cards = Array.new
  end
  
  def shuffle
    @cards.shuffle!
  end
  
  def draw
    return @cards.pop
  end
  
end