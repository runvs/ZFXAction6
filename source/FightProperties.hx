package ;
import flixel.util.FlxRandom;

/**
 * ...
 * @author 
 */
class FightProperties
{
	
	public function new() 
	{
		AttackDamage = 1;
		AttackHitChance = 0.75;
		EvadeChance = 0.025;
		SpecialAttackDamage = 3;
		SpecialAttackNeeded = 3;
		SpecialAttackCollected = 0;
		ArmorReduction = 0.5;
		
		HealthCurrent = HealthMax = 6;
		
		IsDefending = false;
		
		FleeChance = 0.34;
		
	}
	
	public var AttackDamage : Float;
	public var AttackHitChance : Float;
	
	public var EvadeChance : Float;	// 0 to 1
	
	public var SpecialAttackDamage : Float;
	public var SpecialAttackNeeded : Int;
	public var SpecialAttackCollected : Int;
	
	public var ArmorReduction : Float;	// 0 to 1
	
	public var HealthCurrent : Float;
	public var HealthMax : Float;
	
	public var IsDefending : Bool;
	
	public var FleeChance : Float; 	
	
	
	public function DoAttack (target:FightProperties) : Int
	{
		
		// calculate values
		var armorReduction : Float = target.ArmorReduction;
		var damage : Float  = this.AttackDamage * ((target.IsDefending) ? armorReduction : 1.0 );
		var evadeChance : Float = target.EvadeChance * ((target.IsDefending) ? 2.0 : 1.0);	// double the chance if the target is definding
		
		if (evadeChance > 0.8)
		{
			evadeChance = 0.8;
		}
		if (armorReduction > 0.8)
		{
			armorReduction = 0.8;
		}
	
		
		if (!FlxRandom.chanceRoll(evadeChance*100))
		{
			if (FlxRandom.chanceRoll(AttackHitChance * 100))
			{
				// target did not evade
				target.HealthCurrent -= damage;
				return Math.round(damage);
			}
		}
		
		return 0;
	}
	
	
	public function DoSpecialAttack (target:FightProperties) : Int
	{
		var ret : Int = 0;
		this.AttackDamage *= 2.0;	// a simple double damage attack
		ret = DoAttack(target);
		this.AttackDamage /= 2.0;	
		SpecialAttackCollected = -1;
		
		return ret;
		
	}
	
	public function DoFlee (target:FightProperties ) : Bool 
	{
		return FlxRandom.chanceRoll(FleeChance*100);
	}

	public function DoAddSpecial () : Void 
	{
		if ( SpecialAttackCollected < SpecialAttackNeeded)
		{
			SpecialAttackCollected++;
		}
	}
	
}