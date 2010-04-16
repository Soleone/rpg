module RPG
  
  class Character
    extend Forwardable
    include Serializable
    include Fighting
    
    def_delegator :@equipment, :add, :equip
    def_delegator :@equipment, :remove, :unequip
    def_delegator :@equipment, :include?, :equipped?

    DEFAULT_ATTRIBUTE_VALUE = 10
    attr_accessor :name
    attr_accessor :strength, :agility, :charisma, :constitution, :intelligence
    attr_reader :health, :inventory, :equipment
    
    def initialize(name = nil)
      @name = name
      @inventory = Inventory.new(self)
      @equipment = Inventory.new(self)
      @strength = @health = @agility = @charisma = @constitution = @intelligence = DEFAULT_ATTRIBUTE_VALUE
      yield self if block_given?
    end
        
    def damage
      weapon ? weapon.damage : Dice.new(strength / 4)
    end
    
    def weapon
      equipment.weapons.first
    end
    
    def armor
      equipment.armor.inject
    end
    
    def decrease(attribute, amount, min = nil)
      value = instance_variable_get("@#{attribute}")
      new_value = value - amount
      new_value = min if min && new_value < min
      instance_variable_set("@#{attribute}", new_value)
    end
    
    def increase(attribute, amount, max = nil)
      value = instance_variable_get("@#{attribute}")
      new_value = value + amount
      new_value = max if max && new_value > max
      instance_variable_set("@#{attribute}", new_value)
    end
    
    def roll(type, modifier = 0)
      raise "Can't make a roll for type '#{type}'" unless %w[attack evade].include?(type.to_s)

      character_value = send(type)
      dice = 1.d20 + modifier
      dice_roll = dice.roll(character_value)
      RPG.output "<#{type.to_s.capitalize}> Rolled #{dice_roll} (needed #{character_value} or less)"
      # dice_roll.to_i <= character_value
      dice_roll
    end
    
  end
  
end