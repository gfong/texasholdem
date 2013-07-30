require_relative 'Card'

class HandEvaluator
  
  COMBO_VALUE_MULTIPLIER = 75
  PAIR_VALUE = 2000
  THREE_OF_A_KIND_VALUE = 6000
  STRAIGHT_VALUE = 8000
  FLUSH_VALUE = 9000
  #Full house value = three of a kind value + pair value + modifier
  FULL_HOUSE_MODIFIER = 4000
  FOUR_OF_A_KIND_VALUE = 15000
  STRAIGHT_FLUSH_VALUE = 30000
  ROYAL_FLUSH_VALUE = 50000
  
  def initialize()
    @new_hand = nil
    @hand_value = 0
    @temp_array = Array.new
    @hand_type = "High Card"
  end
 
  def evaluate_hand(hand)
    @new_hand = hand
    @hand_value = 0
    if(hand_has_royal_flush?(hand))
      reorganize_hand(hand)
      @hand_value = ROYAL_FLUSH_VALUE + @new_hand[0].get_suit
      @hand_type = "Royal Flush"
    elsif(hand_has_straight_flush?(hand))
      reorganize_hand(hand)      
      @hand_value = STRAIGHT_FLUSH_VALUE + (@new_hand[0].get_index + @new_hand[0].get_suit) + (@new_hand[1].get_index)
      @hand_type = "Straight Flush"
    elsif(hand_has_four_of_a_kind?(hand))
      reorganize_hand(hand)
      @hand_type = "Four of a Kind"
    elsif(hand_has_full_house?(hand))
      @hand_type = "Full House"
    elsif(hand_has_flush?(hand))
      reorganize_hand(hand)
      @hand_type = "Flush"
    elsif(hand_has_straight?(hand))
      reorganize_hand(hand)
      @hand_value += STRAIGHT_VALUE + (@new_hand[0].get_index + @new_hand[0].get_suit) + (@new_hand[1].get_index)
      @hand_type = "Straight"
    elsif(hand_has_three_of_a_kind?(hand))
      reorganize_hand(hand)
      @hand_type = "Three of a Kind"
    elsif(hand_has_pairs?(hand))
      reorganize_hand(hand)
      if(@temp_array.length == 2)
        @hand_type = "Pair"
      else
        @hand_type = "Two Pair"
      end
    else
      evaluate_high_card(hand)
    end
    return [@new_hand, @hand_value, @hand_type]
  end
  
  #---Check for royal flush---
  def hand_has_royal_flush?(hand)
    has = false
    hands = hand.combination(5)
    hands.each{|x| 
      nums = Array.new
      x.each{|y| nums.push(y.get_value)}
      if (hand_has_flush?(x) && nums.include?(13) && nums.include?(12) && nums.include?(11) && nums.include?(10) && nums.include?(9))
        has = true
        break
      end
    }  
    return has
  end
  
  #Check if hand has straight flush
  def hand_has_straight_flush?(hand)
    has = false
    @temp_array = Array.new
    @hand_value = 0
    
    hands = hand.combination(5)
    hands.each{|x| 
      if (hand_has_flush?(x) && hand_has_straight?(x))
        has = true
        @temp_array = x
        break
      end
    }  
    return has
  end
  
  #Check if hand has four of a kind
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
        match_counter += 1
        if(match_counter == 4)
          has = true
          @temp_array << hand[i]
          @temp_array << hand[i-1]
          @temp_array << hand[i-2]
          @temp_array << hand[i-3]
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
  
  #Check if hand has full house
  def hand_has_full_house?(hand)
    @temp_array = Array.new
    has = hand_has_three_of_a_kind? hand 
    if(has)
      three_of_a_kind = Array.new
      three_of_a_kind << @temp_array[0]
      three_of_a_kind << @temp_array[1]
      three_of_a_kind << @temp_array[2]
      
      has = hand_has_pairs?(@new_hand - @temp_array)
      if(has)
        reorganize_hand @new_hand
        @new_hand = three_of_a_kind + @new_hand
        @temp_array = three_of_a_kind + @temp_array
        @new_hand = @temp_array + (@new_hand - @temp_array)
        combo_value = 0
        for i in 0...5
          combo_value += hand[i].get_value
        end
        @hand_value += FULL_HOUSE_MODIFIER + COMBO_VALUE_MULTIPLIER * @temp_array[0].get_value
      end 
    end
    return has
  end
  
  def hand_has_flush?(hand)
    has = false
    @temp_array = Array.new
    @hand_value = 0
    tp = Array.new
    hand.each{|x| tp.push(x.get_suit_name)}
    clubs = 0;hearts=0;spades=0;diamonds=0;
    tp.each{|x| if x == 'c'
      clubs = clubs+1
      elsif x == 'h'  
        hearts = hearts+1
      elsif x == 's'  
        spades = spades+1
      elsif x == 'd'  
        diamonds = diamonds+1
      end
      }
      winner = -1
      if clubs > 4
        winner = 1
      elsif hearts > 4
        winner = 2
      elsif spades > 4
        winner = 3
      elsif diamonds > 4
        winner = 0
      end
      
      if winner != -1
        has = true
        hand = (hand.sort_by {|c| c.get_compare_value}).reverse
        for i in 0...hand.length
          if(hand[i].get_suit == winner)
            @temp_array << hand[i]
          end 
        end
        @hand_value += FLUSH_VALUE + COMBO_VALUE_MULTIPLIER * (@temp_array[0].get_suit + 1)
      end
    return has
  end
  
  #---Check for straight---
  def hand_has_straight?(hand)
    @temp_array = Array.new
    @hand_value = 0
    has = false
    
    hands = hand.combination(5)
    hands.each{|x| 
      tp = Array.new
      x.each{|y|tp.push(y.get_value)}
      tp.sort!
      tp.uniq!
       
      if(tp.include?(13) && tp.include?(1) && tp.include?(2) && tp.include?(3) && tp.include?(4) ||
        tp.include?(1) && tp.include?(2) && tp.include?(3) && tp.include?(4) && tp.include?(5) ||
        tp.include?(2) && tp.include?(3) && tp.include?(4) && tp.include?(5) && tp.include?(6) ||
        tp.include?(3) && tp.include?(4) && tp.include?(5) && tp.include?(6) && tp.include?(7) ||
        tp.include?(4) && tp.include?(5) && tp.include?(6) && tp.include?(7) && tp.include?(8) ||
        tp.include?(5) && tp.include?(6) && tp.include?(7) && tp.include?(8) && tp.include?(9) ||
        tp.include?(6) && tp.include?(7) && tp.include?(8) && tp.include?(9) && tp.include?(10) ||
        tp.include?(7) && tp.include?(8) && tp.include?(9) && tp.include?(10) && tp.include?(11) ||
        tp.include?(8) && tp.include?(9) && tp.include?(10) && tp.include?(11) && tp.include?(12) ||
        tp.include?(9) && tp.include?(10) && tp.include?(11) && tp.include?(12) && tp.include?(13)
        )
        has = true
        @temp_array = (x.sort_by {|c| c.get_index})
        break
      end
    }  
    return has
  end
  
  #---Check for three of a kind---
  def hand_has_three_of_a_kind?(hand)
    has = false
    
    #Used to hold pairs in this case
    @temp_array = Array.new 
    
    #Get all three of a kinds from hand
    hand = (hand.sort_by {|c| c.get_compare_value}).reverse
    current = hand[0]
    match_counter = 1
    for i in 1...hand.length
      if(current.get_value == hand[i].get_value && match_counter < 3)
        match_counter += 1
        if(match_counter == 3)
          has = true
          @temp_array << hand[i]
          @temp_array << hand[i-1]
          @temp_array << hand[i-2]
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
        if((!@temp_array.include? hand[i]) && 
            (!@temp_array.include? hand[j]) && 
            hand[i].get_value == hand[j].get_value)
          has = true
          @temp_array << hand[i]
          @temp_array << hand[j]
          if @temp_array.length <= 4 
            @hand_value += PAIR_VALUE + COMBO_VALUE_MULTIPLIER * (hand[i].get_value)
          end
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