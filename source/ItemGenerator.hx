class ItemGenerator
{
	private var itemsByChance:Array<Items>;
	private var dropTable:Map<Items, Int>;
	private var _maximumIndex:Int;

	public function new()
	{
		dropTable = new Map<Items, Int>();
		dropTable.set(Items.Lack, 1);
		dropTable.set(Items.Nordli, 1);
		dropTable.set(Items.Pax, 1);
		
		dropTable.set(Items.Screw114671, 2);
		dropTable.set(Items.Screw122044, 2);
		dropTable.set(Items.Pin102370, 2);
		dropTable.set(Items.Plug0033451, 2);
		
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
			case Nordli:
				return new Nordli();
			case Pax:
				return new Pax();
			case Screw114671:
				return new Screw114671();
			case Pin102370:
				return new Pin102370();
			case Screw122044:
				return new Screw122044();
			case Plug0033451:
				return new Plug0033451();
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