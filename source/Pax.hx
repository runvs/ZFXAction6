package ;

/**
 * ...
 * @author 
 */
class Pax extends Item
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
			player._fightingProperties.ArmorReduction += 0.005;

			consumed = true;
		}
	}

	public override function getName():String
	{
		return "Pax";
	}
	
	public override function getInfo():String
	{
		return "Armor + 0.5%";
	}
	
}