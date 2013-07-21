require_relative 'Card'

class HandEvaluator
  
  def initialize()
    @new_hand = nil
    @hand_value = 0
  end
 
  def evaluate_hand(hand)
    @new_hand = hand
    if(hand_has_royal_flush?(hand))
    elsif(hand_has_straight_flush?(hand))
    elsif(hand_has_four_of_a_kind?(hand))
    elsif(hand_has_full_house?(hand))
    elsif(hand_has_flush?(hand))
    elsif(hand_has_straight?(hand))
    elsif(hand_has_three_of_a_kind?(hand))
    elsif(hand_has_two_pair?(hand))
    elsif(hand_has_pair?(hand))
    else
      evaluate_high_card(hand)
    end 
    return [@new_hand, @hand_value]
  end
  
  def hand_has_royal_flush?(hand)
    return false
  end
  
  def hand_has_straight_flush?(hand)
    return false
  end
  
  def hand_has_four_of_a_kind?(hand)
    return false
  end
  
  def hand_has_full_house?(hand)
    return false
  end
  
  def hand_has_flush?(hand)
    return false
  end
  
  def hand_has_straight?(hand)
    return false
  end
  
  def hand_has_three_of_a_kind?(hand)
    return false
  end
  
  def hand_has_two_pair?(hand)
    return false
  end
  
  def hand_has_pair?(hand)
    pairs = Array.new
    returnValue = false
    hand.permutation(2).to_a.each {|x| 
      if (x[0].get_value == x[1].get_value)then returnValue = true
        pairs.push([x[0], x[1]])
      end}
      puts pairs.inspect
    return returnValue
  end
  
  def evaluate_high_card(hand)
    
    #Find high card
    high_card = hand[0]
    hand.each do |c|
      high_card = (c.get_compare_value > high_card.get_compare_value) ? c : high_card
    end
    
    #Find kicker
    kicker = hand[1]
    hand.each do |c|
      challenger_value = c.get_compare_value
      better_than_kicker = challenger_value > kicker.get_compare_value
      less_than_high_card = challenger_value < high_card.get_compare_value
      kicker = (better_than_kicker && less_than_high_card) ? c : kicker
    end
    
    #Position high card in front and kicker second
    hand.delete(high_card)
    @new_hand = hand.insert(0, high_card)
    @new_hand.delete(kicker)
    @new_hand.insert(1, kicker)
    
    #Set the hand value
    @hand_value = high_card.get_compare_value + kicker.get_compare_value
  end
end