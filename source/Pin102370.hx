package ;

/**
 * ...
 * @author 
 */
class Pin102370 extends Item
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
		return "Pin102370";
	}
	
	public override function getInfo():String
	{
		return "Crafting";
	}
	
}