require_relative 'Card'

class HandEvaluator
  
  COMBO_VALUE_MULTIPLIER = 75
  PAIR_VALUE = 2000
  THREE_OF_A_KIND_VALUE = 6000
  STRAIGHT_VALUE = 8000
  FLUSH_VALUE = 10000
  #Full house value = three of a kind value + pair value + modifier
  FULL_HOUSE_MODIFIER = 3000
  FOUR_OF_A_KIND_VALUE = 15000
  STRAIGHT_FLUSH_VALUE = 30000
  ROYAL_FLUSH_VALUE = 50000
  
  def initialize()
    @new_hand = nil
    @hand_value = 0
    @temp_array = Array.new
  end
 
  def evaluate_hand(hand)
    @new_hand = hand
    @hand_value = 0
    if(hand_has_royal_flush?(hand))
      reorganize_hand(hand)
    elsif(hand_has_straight_flush?(hand))
      reorganize_hand(hand)
    elsif(hand_has_four_of_a_kind?(hand))
      reorganize_hand(hand)
    elsif(hand_has_full_house?(hand))
      reorganize_hand(hand)
    elsif(hand_has_flush?(hand))
      reorganize_hand(hand)
    elsif(hand_has_straight?(hand))
      reorganize_hand(hand)
    elsif(hand_has_three_of_a_kind?(hand))
      reorganize_hand(hand)
    elsif(hand_has_pairs?(hand))
      reorganize_hand(hand)
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
    has = false
    
    #Used to hold pairs in this case
    @temp_array = Array.new 
    
    #Get all three of a kinds from hand
    hand = (hand.sort_by {|c| c.get_compare_value}).reverse
    current = hand[0]
    match_counter = 1
    for i in 1...hand.length
      if(current.get_value == hand[i].get_value)
        #puts "Match! " + current.inspect + " " + hand[i].inspect
        match_counter += 1
        if(match_counter == 4)
          has = true
          @temp_array << hand[i]
          @temp_array << hand[i-1]
          @temp_array << hand[i-2]
          @temp_array << hand[i-3]
          #print "Three of a kind! " + @temp_array.to_s
          @hand_value += FOUR_OF_A_KIND_VALUE + COMBO_VALUE_MULTIPLIER * (hand[i].get_value)
          break
        end
      else
        match_counter = 1
        current = hand[i]     
      end
    end
    return has
  end
  
  def hand_has_full_house?(hand)
    #has = hand_has_three_of_a_kind? hand && hand_has_pairs?(@new_hand)
    return false
  end
  
  def hand_has_flush?(hand)
    return false
  end
  
  def hand_has_straight?(hand)
    has=false
    @temp_numbers = Array.new
    hand.each{|x|@temp_numbers.push(x.get_value)}
    @temp_numbers.each{|x|print x}
    return has
  end
  
  def hand_has_three_of_a_kind?(hand)
    has = false
    
    #Used to hold pairs in this case
    @temp_array = Array.new 
    
    #Get all three of a kinds from hand
    hand = (hand.sort_by {|c| c.get_compare_value}).reverse
    current = hand[0]
    match_counter = 1
    for i in 1...hand.length
      if(current.get_value == hand[i].get_value)
        #puts "Match! " + current.inspect + " " + hand[i].inspect
        match_counter += 1
        if(match_counter == 3)
          has = true
          @temp_array << hand[i]
          @temp_array << hand[i-1]
          @temp_array << hand[i-2]
          #print "Three of a kind! " + @temp_array.to_s
          @hand_value += THREE_OF_A_KIND_VALUE + COMBO_VALUE_MULTIPLIER * (hand[i].get_value)
          break
        end
      else
        match_counter = 1
        current = hand[i]     
      end
    end
    return has
  end
  
  def hand_has_pairs?(hand)
    has = false
    
    #Used to hold pairs in this case
    @temp_array = Array.new 
    
    #Get all pairs from hand
    for i in 0...(hand.length - 1)
      for j in (i + 1)...hand.length
        if(@temp_array.length < 4 && 
            (!@temp_array.include? hand[i]) && (!@temp_array.include? hand[j]) && 
            hand[i].get_value == hand[j].get_value)
          has = true
          @temp_array << hand[i]
          @temp_array << hand[j]
          @hand_value += PAIR_VALUE + COMBO_VALUE_MULTIPLIER * (hand[i].get_value)
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
      #Values higher in the list are worth more
      @hand_value += hand[i].get_compare_value * 2 ** (selected_card_count - i) / 8
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