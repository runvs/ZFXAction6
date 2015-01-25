package ;

/**
 * ...
 * @author 
 */
class Screw114671 extends Item
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
			consumed = true;
		}
	}

	public override function getName():String
	{
		return "Screw114671";
	}
	
	public override function getInfo():String
	{
		return "Crafting";
	}
	
	
	
}