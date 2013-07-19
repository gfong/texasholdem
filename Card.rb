class Card
  
  def initialize(value, suit)
    @value = value
    @suit = suit
  end
  
  def get_value
    return @value
  end
  
  def get_suit
    return @suit
  end
  
  def get_compare_value
    return @value * @suit
  end
  
  def inspect
    valueChar = @value + 1 
    if valueChar == 11
      valueChar = "J"
    elsif valueChar == 12
      valueChar = "Q"
    elsif valueChar == 13
      valueChar = "K"
    end
    suitChar = @suit
    if @suit == 0
      suitChar = "d"
    elsif @suit == 1
      suitChar = "c"
    elsif @suit == 2
      suitChar = "h"
    elsif @suit == 3
      suitChar = "s"
    end
    return valueChar.to_s + suitChar.to_s
  end
end