module RPG

  class Dice
    def initialize(max, modifier = 0, amount = 1)
      @max, @modifier, @amount = max, modifier, amount
    end
  
    def +(modifier)
      @modifier = modifier
      self
    end
  
    def -(modifier)
      @modifier = -modifier
      self
    end
  
    def roll
      (1..@amount).inject(0){|total, _| total + (rand(@max) + 1) } + @modifier
    end
  
    def to_s
      string = "#{@amount}d#{@max}"
      string << "#{@modifier > 0 ? '+' : '-'}#{@modifier}" if @modifier != 0
      string
    end

    def to_range
      min, max = 1 + @modifier, @max + @modifier
      min..max
    end
    
    def hash
      (@max * 1000) + (@modifier * 100) + @amount
    end
  
    def eql?(other)
      hash == other.hash
    end
  
    def ==(other)
      eql?(other)
    end
  
    def self.roll(max = 20, modifier = 0)
      new(max, modifier).roll
    end
  end
  
end