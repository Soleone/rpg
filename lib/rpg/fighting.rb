module RPG

  class Hit < Event
    attr_reader :character, :attacker, :damage

    def initialize(character, attacker, damage)
      super(attacker)
      @character, @attacker, @damage = character, attacker, damage
    end
  end


  module Fighting
    # Example: goblin.fight(tank)
    # 1. goblin rolls for successful hit
    # 2. tank tolls for evade
    # 3. tank takes damage if not evaded
    def fight(character)
      puts "#{name} fights #{character.name}"
      
      if not roll(:attack)
        on_attack_fail
        return
      end
      on_attack_success
      
      if character.roll(:evade)
        character.on_evade
        return
      end
      
      hit = Hit.new(character, self, damage)      
      character.on_hit(hit)
    end

    # fight till the death
    def duel(character)
      loop do
        fight(character)
        character.fight(self)
        break if [self, character].any?{|c| c.dead? }
      end
    end

    def on_hit(hit)
      actual_damage = hit.damage.roll
      decrease :health, actual_damage
      puts "#{name} got hit by #{hit.attacker.name} for #{actual_damage} damage (#{hit.damage}) and has #{health} health left"
      on_death if dead?
    end
    
    def on_death
      puts "#{name} dies#{' in pain' if health < -5}"
    end
    
    def dead?
      health <= 0
    end
    
    def on_evade
      puts "#{name} evades the attack"
    end
        
    def on_attack_success
      
    end
    
    def on_attack_fail
      puts "#{name} fails to hit with his attack"  
    end

    
    def evade
      (agility + strength + constitution) / 3
    end
    
    def attack
      (agility + strength) / 2
    end
        
    def roll(type, modifier = 0)
      return unless %w[attack evade].include?(type.to_s)

      dice = 1.d20 + modifier
      roll_value = dice.roll
      character_value = send(type)
      puts "[#{type.to_s.capitalize}] Rolled <#{roll_value}> with #{dice.to_s} (needed #{character_value} or less)"
      roll_value <= character_value
    end
  end

end