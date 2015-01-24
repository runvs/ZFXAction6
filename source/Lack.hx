class Lack extends Item
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
			player.GetFightProperties().AttackDamage + 1;

			consumed = true;
		}
	}

	public override function getName():String
	{
		return "Lack";
	}
}