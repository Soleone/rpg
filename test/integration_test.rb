require File.dirname(__FILE__) + '/test_helper'

class IntegrationTest < Test::Unit::TestCase
  def setup
    @hero  = RPG::Character.new("Hero")
    @enemy = RPG::Character.new("Enemy")
    @sword = RPG::Weapon.new("Sword", 1.d6+1)
  end
  
  def test_character_customization
    @hero.name = "My Hero"
    @hero.strength = 16
    @hero.agility = 12
    
    assert_equal "My Hero", @hero.name
    assert_equal 16, @hero.strength
    assert_equal 12, @hero.agility
  end
  
  def test_fight
    # TODO: round 1... fight!
  end
end