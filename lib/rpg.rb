require 'forwardable'
require 'yaml'
require 'logger'

lib = %w[serializable dice event fighting character core_extensions]
lib.each do |file|
  require "#{File.dirname(__FILE__)}/rpg/#{file}"
end


module RPG
  
  class SimpleLogger < Logger
    def initialize(output = STDOUT)
      super(output)
    end
    def format_message(severity, timestamp, progname, msg)
      "#{msg}\n"
    end
    
    def puts(text)
      info(text)
    end
  end
  
  @logger = SimpleLogger.new
  
  def self.output=(logger)
    @logger = logger
  end
  
  def self.output(text)
    @logger.puts(text)
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