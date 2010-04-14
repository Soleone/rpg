require 'test/unit'
require File.dirname(__FILE__) + '/../lib/rpg'


class Test::Unit::TestCase
  def assert_not(expected)
    assert_block("Expected <#{expected}> to be false or nil."){ !expected }
  end
  
  def assert_between(expected, min, max)
    assert_block("Expected <#{expected}> to be between #{min} and #{max}.") do
      expected >= min && expected <= max
    end
  end
end