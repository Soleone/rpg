require File.dirname(__FILE__) + '/test_helper'
include RPG

class CharacterTest < Test::Unit::TestCase
  def setup
    @char = Character.new("Someone")
    @sword = Weapon.new("Sword", 1.d6+1)
  end  

  def has_name
    assert_equal "Someone", char.name
  end
  
  def test_has_basic_attributes
    assert @char.strength
    assert @char.agility
    assert @char.constitution
    assert @char.intelligence
    assert @char.charisma
  end
  
  def test_has_inventory
    assert_equal [], @char.inventory.items
    @char.inventory << @sword
    assert_equal [@sword], @char.inventory.weapons
  end
  
  def test_can_equip
    @char.equip(@sword)
    assert @char.equipped?(@sword)
    
    @char.unequip(@sword)
    assert_not @char.equipped?(@sword)
  end
  
  def test_damage_is_based_on_weapon
    @char.equip(@sword)
    assert_equal 1.d6+1, @char.damage
  end
  
  def test_damage_is_based_on_strength_when_no_weapon_equipped
    assert_equal Dice.new(2), @char.damage
    @char.strength = 16
    assert_equal Dice.new(4), @char.damage
    @char.strength = 19
    assert_equal Dice.new(4), @char.damage
    @char.strength = 20
    assert_equal Dice.new(5), @char.damage    
  end
  
  def test_deserialize_from_yml
    goblin = Character.from_yaml(CHARACTERS_PATH, 'goblin')
    assert_equal 12, goblin.strength
    assert_equal 14, goblin.agility
    assert_equal 10, goblin.intelligence
    assert_equal 8, goblin.charisma
    assert_equal 12, goblin.constitution
  end
end


class DiceTest < Test::Unit::TestCase
  def test_lazy_rolling
    dice = Dice.new(4, +1)
    roll = dice.roll
    assert_between(dice.roll.to_i, 2, 5)
  end
  
  def test_fixnum_extension
    roll = 1.d6.roll
    assert_between(roll.to_i, 1, 6)
  end
  
  
  def test_roll_d20
    roll = Dice.roll
    assert_between(roll.to_i, 1, 20)
  end
  
  def test_roll_d6
    roll = Dice.roll(6)
    assert_between(roll.to_i, 1, 6)
  end
  
  def test_roll_d4
    roll = Dice.roll(4)
    assert_between(roll.to_i, 1, 4)
  end
  
  def test_roll_d2
    roll = Dice.roll(2)
    assert_between(roll.to_i, 1, 2)
  end
  
  def test_to_range
    assert_equal 1..6, 1.d6.to_range
    assert_equal 3..8, (1.d6+2).to_range
    assert_equal 2..21, (1.d20+1).to_range
    assert_equal -6..-1, (1.d6-7).to_range
    assert_equal 2..12, 2.d6.to_range
    assert_equal 10..35, (5.d6 + 5).to_range
  end
  
  def test_epic_win_or_fail
    100.times do
      roll = 1.d6.roll
      assert roll.epic_fail? if roll == 1
      assert roll.epic_win? if roll == 6
    end
  end
end


class WeaponTest < Test::Unit::TestCase
  def setup
    @sword = Weapon.new("Sword", 1.d6+1)
  end

  def test_damage_is_a_dice_roll
    assert_equal Dice, @sword.damage.class
    assert_equal "1d6+1", @sword.damage.to_s    
  end
  
  def test_damage_is_randomly_rolled
    100.times do
      roll = @sword.damage.roll
      assert_between(roll.to_i, 1, 7)
    end
  end
end


class InventoryTest < Test::Unit::TestCase
  def setup
    @char = Character.new("Someone")
    @inventory = Inventory.new(@char)
    @sword = Weapon.new("Sword", 1.d6+1)
  end
  
  def test_can_add_items
    @inventory << "something"
    @inventory.add "something else"
    assert_equal ["something", "something else"], @inventory.all
  end
  
  def test_get_weapons
    @inventory << @sword
    assert_equal [@sword], @inventory.weapons
  end
end


class EventTest < Test::Unit::TestCase
  def setup
    @goblin = characters('goblin')
    @tank = characters('tank')
    @club = Weapon.new("Club", 1.d4+1)
  end
  
  def test_attack_success_creates_event
    @tank.increase :strength, 20, 20
    @tank.increase :agility, 20, 20
    @tank.increase :intelligence, 20, 20    
    @tank.fight(@goblin)
    assert_equal 1, Event.all(:attack_success).size
    event = Event.all(:attack_success).first
    assert_equal [@tank], event.listeners
  end
end

