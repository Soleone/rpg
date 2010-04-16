module RPG

  class Hit < Event
    attr_reader :character, :attacker, :damage

    def initialize(character, attacker, damage, critical = false)
      super(:hit, character, attacker)
      @character, @attacker, @damage = character, attacker, damage
      @critical = critical
    end
    
    def critical?
      @critical
    end
  end


  module Fighting
    # Example: goblin.fight(tank)
    # 1. goblin rolls for successful hit
    # 2. tank tolls for evade
    # 3. tank takes damage if not evaded
    def fight(character)
      RPG.output "#{name} attacks #{character.name}"
      
      attack_roll = roll(:attack)
      if attack_roll.fail?
        Event.fire(:attack_fail, self)
        return
      end
      Event.fire(:attack_success, self)

      evade_roll = character.roll(:evade)
      if evade_roll.success?
        Event.fire(:evade, character)
        return
      end
      
      critical_hit = attack_roll.epic_win?
      Hit.fire(character, self, damage, critical_hit)
    end

    # fight till the death
    def duel(character)
      loop do
        fight(character)
        character.fight(self)
        break if [self, character].any?{|c| c.dead? }
      end
    end

    # when dealing a successful hit or when being hit
    def on_hit(hit)
      if hit.attacker == self
        RPG.output "#{self.name} landed a Critical Hit" if hit.critical?
        return
      end
      
      damage_roll = hit.damage.roll
      critical_modifier = hit.critical? ? 2 : 1
      final_damage = damage_roll.to_i * critical_modifier
      decrease :health, final_damage
      RPG.output "#{name} got#{' critically' if hit.critical?} hit by #{hit.attacker.name} for #{final_damage} damage (#{hit.damage}) and has #{health} health left"
      Event.fire(:death, self) if dead?
    end
    
    def on_event(event)
      case event.type
      when :attack_success
      
      when :attack_fail
        RPG.output "#{name} fails to hit with his attack"
      when :hit

      when :death
        RPG.output "#{name} dies#{' in pain' if health < -5}"
      when :evade
        RPG.output "#{name} evades the attack"        
      end
    end
    
    def dead?
      health <= 0
    end
    
    
    def evade
      (strength + agility + constitution) / 3
    end
    
    def attack
      (strength + agility + intelligence) / 3
    end
  end

end