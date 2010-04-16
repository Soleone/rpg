module RPG

  class Dice
    class Roll
      attr_reader :dice, :result, :max

      def initialize(result, dice, max = nil)
        @result, @dice, @max = result, dice, max
      end
    
      # remember: low score is better
      def epic_win?
        result == dice.to_range.min
      end
      
      def epic_fail?
        result == dice.to_range.max
      end
      
      def success?
        raise "No max value to compare against" unless max
        result <= max
      end
      
      def fail?
        !success?
      end
      
      def to_i
        result
      end
      
      def to_s
        "[#{to_i}] with #{dice.to_s}"
      end
    end
    
    
    attr_reader :max, :modifier, :amount
    
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
  
    def roll(max_allowed = nil)
      result = (1..amount).inject(0){|total, _| total + (rand(max) + 1) } + modifier
      Roll.new(result, self, max_allowed)
    end
  
    def to_s
      string = "#{amount}d#{max}"
      string << "#{modifier > 0 ? '+' : '-'}#{modifier}" if modifier != 0
      string
    end

    def to_range
      range_min, range_max = (1 * amount) + modifier, (max * amount) + modifier
      range_min..range_max
    end
    
    def hash
      (max * 1000) + (modifier * 100) + amount
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