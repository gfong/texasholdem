require_relative 'Game'

class Main
  
  def initialize
    game = Game.new
    game.start
    while true
      gets.chomp
      game.start
    end
  end
  
end

Main.new