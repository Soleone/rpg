require 'forwardable'

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


  module Fighting
    class Hit
      attr_reader :character, :attacker, :damage
      
      def initialize(character, attacker, damage)
        @character, @attacker, @damage = character, attacker, damage
      end
    end
    
    def attack(character)
      puts "#{name} attacks #{character.name}"
      damage = 
      hit = Hit.new(character, damage)
      character.hit!(hit)
    end
    
    def hit!(hit)
      puts "#{name} got hit by #{hit.attacker.name} for #{hit.damage} damage"
    end    
  end
  
  
  class Item
    attr_reader :name
    
    def initialize(name)
      @name = name
    end
  end
  
  
  class Weapon < Item
    attr_reader :damage
    
    def initialize(name, damage)
      super(name)
      @damage = damage
    end
  end
  
  
  class Inventory
    extend Forwardable
    include Enumerable
    
    def_delegator :@items, :<<, :add
    def_delegator :@items, :delete, :remove
    def_delegators :@items, :<<, :each

    attr_reader :items
    
    def initialize(character)
      @character = character
      @items, @equipped = [], []
    end
    
    def all(item = nil)
      item ? select{|i| i == item } : items
    end
    
    def count(item)
      all(item).size
    end
    
    def weapons
      select{|item| item.is_a?(Weapon) }
    end    
  end
  
  
  class Character
    extend Forwardable

    def_delegator :@equipment, :add, :equip
    def_delegator :@equipment, :remove, :unequip
    def_delegator :@equipment, :include?, :equipped?

    DEFAULT_ATTRIBUTE_VALUE = 10
    attr_accessor :name
    attr_accessor :strength, :agility, :charisma, :constitution, :intelligence
    attr_reader :health, :inventory, :equipment
    
    def initialize(name)
      @name = name
      @inventory = Inventory.new(self)
      @equipment = Inventory.new(self)
      @strength = @health = @agility = @charisma = @constitution = @intelligence = DEFAULT_ATTRIBUTE_VALUE
    end
        
    def hit_chance
      agility
    end
    
    def damage
      weapon ? weapon.damage : Dice.new(strength / 4)
    end
    
    def weapon
      equipment.weapons.first
    end
  end
end