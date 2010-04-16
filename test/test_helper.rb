require 'test/unit'
require File.dirname(__FILE__) + '/../lib/rpg'

# optional: instead of nil, log output to log file, e.g. File.dirname(__FILE__) + '/../log.txt'
RPG.output = RPG::SimpleLogger.new(nil)

class Test::Unit::TestCase
  CHARACTERS_PATH = "#{File.dirname(__FILE__)}/../data/characters.yml"

  # Custom Assertions
  def assert_not(expected)
    assert_block("Expected <#{expected}> to be false or nil."){ !expected }
  end
  
  def assert_between(expected, min, max)
    assert_block("Expected <#{expected}> to be between #{min} and #{max}.") do
      expected >= min && expected <= max
    end
  end
  
  # helper methods
  def characters(label = nil)
    Character.from_yaml(CHARACTERS_PATH, label)
  end
  
end