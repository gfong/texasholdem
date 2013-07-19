require_relative 'Game'

class Main
  
  def initialize
    game = Game.new
    game.start
  end
  
end

Main.new