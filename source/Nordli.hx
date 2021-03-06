package ;

/**
 * ...
 * @author 
 */
class Nordli extends Item
{

	public function new()
	{
		super();
		consumed = false;
	}

	public override function apply(player:Player):Void
	{
		if(consumed == false)
		{
			player._fightingProperties.HealthMax += 1;
			player._fightingProperties.HealthCurrent += 1;

			consumed = true;
		}
	}

	public override function getName():String
	{
		return "Nordli";
	}
	
	public override function getInfo():String
	{
		return "Health +1";
	}
	
}