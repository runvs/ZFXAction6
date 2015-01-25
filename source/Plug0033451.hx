package ;

/**
 * ...
 * @author 
 */
class Plug0033451 extends Item
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
		return "Plug0033451";
	}
	
	public override function getInfo():String
	{
		return "Crafting";
	}
}