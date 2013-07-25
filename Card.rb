class Card
  
  def initialize(value, suit)
    @value = value
    @suit = suit
  end
  
  def get_value
    converted_value = @value == 0 ? 13 : @value
    return converted_value
  end
  
  def get_suit
    return @suit
  end
  
  def get_compare_value
    converted_value = @value == 0 ? 13 : @value
    return ((converted_value) * 10) + (@suit + 1)
  end
  
  def inspect
    valueChar = @value + 1 
    if valueChar == 1
      valueChar = "A"
    elsif valueChar == 11
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