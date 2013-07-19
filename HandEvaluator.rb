require_relative 'Card'

class HandEvaluator
  
  def initialize()
    @new_hand = nil
    @hand_value = 0
  end
 
  def evaluate_hand(hand)
    @new_hand = hand
    @hand_value = 0
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
    return false
  end
  
  def evaluate_high_card(hand)
    #Sort hand by compare value then reverse
    @new_hand = (hand.sort_by {|c| c.get_compare_value}).reverse
    #Calculate hand value by best 5 cards
    for i in 0...5
      @hand_value += @new_hand[i].get_compare_value
    end
  end
end