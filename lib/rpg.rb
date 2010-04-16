require 'forwardable'
require 'yaml'

lib = %w[serializable dice event fighting character core_extensions]
lib.each do |file|
  require "#{File.dirname(__FILE__)}/rpg/#{file}"
end


module RPG
  
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
  
  class Armor < Item
    attr_reader :armor
    
    def initialize(name, armor)
      super(name)
      @armor = armor
    end
  end

  
end