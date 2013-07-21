require_relative 'Card'

class HandEvaluator
  
  def initialize()
    @new_hand = nil
    @hand_value = 0
    @temp_array = Array.new
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
    elsif(hand_has_pairs?(hand))
      reorganize_hand(hand)
    else
      puts "Evaluating high card."
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
  
  def hand_has_pairs?(hand)
    has = false
    
    #Used to hold pairs in this case
    @temp_array = Array.new 
    
    #Get all pairs from hand
    for i in 0...(hand.length - 1)
      for j in (i + 1)...hand.length
        if(@temp_array.length <= 4 && 
            (!@temp_array.include? hand[i]) && (!@temp_array.include? hand[j]) && 
            hand[i].get_value == hand[j].get_value)
          has = true
          @temp_array << hand[i]
          @temp_array << hand[j]
          @hand_value += 1000 + 150 * (hand[i].get_value)
        end 
      end
    end
    return has
  end
  
  def evaluate_high_card(hand)
    #Sort hand by compare value then reverse
    @new_hand = (hand.sort_by {|c| c.get_compare_value}).reverse
    calculate_hand_value(@new_hand, 5)
  end
  
  def calculate_hand_value(hand, selected_card_count)
    #Calculate hand value by selected number of cards
    for i in 0...selected_card_count
      @hand_value += hand[i].get_compare_value
    end
  end
  
  def reorganize_hand(hand)
    hand = hand - @temp_array
    @temp_array = (@temp_array.sort_by {|c| c.get_compare_value}).reverse
    hand = (hand.sort_by {|c| c.get_compare_value}).reverse
    calculate_hand_value(hand, 5 - @temp_array.length)
    @new_hand = @temp_array + hand
  end
end