require_relative 'Deck'
require_relative 'Card'
require_relative 'HandEvaluator'

class Game
  
  def initialize()
    @deck = nil
    @community_cards = Array.new
    @burned_cards = Array.new
    @players = Array.new
    @player_count = 5
    @player_hands_and_values = Hash.new
    @hand_evaluator = HandEvaluator.new
  end
  
  def start
    puts "Game starting..."
    
    #Create a new deck and shuffle it
    puts "Created deck and shuffling..."
    @deck = Deck.new
    @deck.generate
    @deck.shuffle
    
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
      @player_hands_and_values[hand_and_value[0]] = hand_and_value[1]
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
      print "\t value: " + v.to_s + "\n"
    end
  end
end