require_relative 'Deck'
require_relative 'Card'
require_relative 'HandEvaluator'

class Game
  
  def initialize()
    @deck = nil
    @player_count = 5
    reset
  end
  
  def reset
    @community_cards = Array.new
    @burned_cards = Array.new
    @players = Array.new
    @player_hands_and_values = Hash.new
    @hand_evaluator = HandEvaluator.new
  end
  
  def start
    reset
    puts "Game starting..."
    
    #Create a new deck and shuffle it
    puts "Created deck and shuffling..."
    @deck = Deck.new
    @deck.generate
    @deck.shuffle
    
    setup_standard_game
    #setup_custom_game
    
    #Show each player's hand
    puts "Displaying each player's hand..."
    @players.each do |p|
      print p[0].inspect + ", " + p[1].inspect
      puts
    end
    
    #Show community cards
    puts "Showing community cards..."
    @community_cards.each do |c|
      print c.inspect + " "
    end
    puts
    
    #Evaluate each hand's value
    puts
    puts "Evaluating each hand's value..."
    @players.each do |p|
      hand = p + @community_cards
      hand_and_value = @hand_evaluator.evaluate_hand(hand)
      @player_hands_and_values[hand_and_value[0]] = [hand_and_value[1], hand_and_value[2]]
      hand_and_value[0].each do |c|
        print c.inspect + ", "
      end
      print "\t value: " + hand_and_value[1].to_s + "\n"
    end
    puts
    
    #Evaluate best hand and display placement
    puts "Evaluating best hand and displaying placement..."
    sorted = @player_hands_and_values.sort {|k, v| k[1] <=> v[1]}
    sorted.reverse!
    sorted.each do |k, v|
      k.each do |c|
        print c.inspect + ", "
      end
      print "\t value: " + v[0].to_s + "\t" + v[1].to_s + "\n"
    end
  end
  
  def setup_standard_game
    #Create player hands and add first card to each hand
    puts "Creating players and adding first cards..."
    for i in 0...@player_count
      @players[i] = Array.new
      @players[i] << @deck.draw
    end
    
    #Add second card to each hand
    puts "Adding second cards..."
    for i in 0...@player_count
      @players[i] << @deck.draw
    end
  
    #Burn a card then draw first three community cards
    puts "Burning card and drawing first three community cards..."
    @burned_cards << @deck.draw
    for i in 0...3
      @community_cards << @deck.draw
    end
    
    #Burn a card then draw a community card, then repeat
    puts "Burning a card and drawing next community card... Then repeat..."
    for i in 0...2
      @burned_cards << @deck.draw
      @community_cards << @deck.draw
    end
  end
  
  def setup_custom_game
    card_1 = Card.new(0, 0)
    card_2 = Card.new(1, 0)
    card_3 = Card.new(3, 3)
    card_4 = Card.new(2, 2)
    card_5 = Card.new(4, 1)
    @community_cards << card_1
    @deck.remove(card_1)
    @community_cards << card_2
    @deck.remove(card_2)
    @community_cards << card_3
    @deck.remove(card_3)
    @community_cards << card_4
    @deck.remove(card_4)
    @community_cards << card_5
    @deck.remove(card_5)
    
    for i in 0...@player_count
      @players[i] = Array.new
      @players[i] << @deck.draw
    end
    
    for i in 0...@player_count
      @players[i] << @deck.draw
    end
  end
end