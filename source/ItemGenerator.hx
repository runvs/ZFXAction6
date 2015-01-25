class ItemGenerator
{
	private var itemsByChance:Array<Items>;
	private var dropTable:Map<Items, Int>;
	private var _maximumIndex:Int;

	public function new()
	{
		dropTable = new Map<Items, Int>();
		dropTable.set(Items.Lack, 5);
		dropTable.set(Items.BollyOfDoom, 1);
		//trace(dropTable);
		itemsByChance = new Array<Items>();
		
		//initialize the array
		var iterator:Iterator<Items> = dropTable.keys();
		while(iterator.hasNext())
		{
			var item:Items = iterator.next();
			//trace(item);
			var chance:Int = dropTable.get(item);
			for(i in 0...chance)
			{
				itemsByChance.push(item);
			}			
		}

		_maximumIndex = sumChances(dropTable);
	}

	public function generateDrop(mobLevel:Int=1):Item
	{
		var randomIndex:Int = flixel.util.FlxRandom.intRanged(0, _maximumIndex - 1);
		// trace("max " + _maximumIndex);
		// trace(itemsByChance);
		// trace(randomIndex);
		return enumToItemLookUp(itemsByChance[randomIndex]);
	}

	public function enumToItemLookUp(item:Items):Item
	{
		switch(item)
		{
			case Lack:
				return new Lack();
			case BollyOfDoom:
				return new Item();
		}

		return null;
	}

	private function sumChances(dropTable:Map<Items, Int>):Int
	{
		var chance:Int;
		var cummulatedChances:Int = 0;
		var iterator:Iterator<Items> = dropTable.keys();
		while(iterator.hasNext())
		{
			cummulatedChances += dropTable.get(iterator.next());
		}

		return cummulatedChances;
	}
}