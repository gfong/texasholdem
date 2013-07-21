require_relative 'Card'

class Deck
  
  def initialize
    @cards = Array.new
  end
  
  def generate
    for value in 0...13
      for suit in 0...4
        card = Card.new(value, suit)
        @cards << card
      end
    end
  end
  
  def shuffle
    @cards.shuffle!
  end
  
  def draw
    return @cards.pop
  end
end