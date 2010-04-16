class Fixnum
  def d4
    RPG::Dice.new(20, 0, self)
  end
  
  def d6
    RPG::Dice.new(6, 0, self)
  end
  
  def d20
    RPG::Dice.new(20, 0, self)
  end
end