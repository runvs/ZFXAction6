class BluePrint 
{
	public var requiredItems:Map<String, Int>;

	public function new()
	{
		requiredItems = new Map<String, Int>();
	}
	
	public function getNumberOfTotalItems () : Int
	{
		var i : Int = 0;
		var iterator:Iterator<String> = requiredItems.keys();
		while(iterator.hasNext())
		{
			var key:String = iterator.next();
			i += requiredItems.get(key);
		}
		return i;
	}
	
	public static function convertArrayToMap (owned: Array<Item>): Map<String, Int>
	{
		var map :  Map<String, Int> = new  Map<String, Int>();
		
		return map;
	}
	
	public function getNumberOfCollectedItems (owned:Map<String, Int>) : Int
	{
		var i : Int = 0;
		var iterator:Iterator<String> = requiredItems.keys();
		while(iterator.hasNext())
		{
			var key:String = iterator.next();
			
			//we have the item
			if(owned.get(key) != null)
			{
				i += ((owned.get(key) >= requiredItems.get(key)) ? requiredItems.get(key) : (owned.get(key) ) );
			}
		}

		return i;
	}

	public function isCraftable(ownedItems:Array<Item>):Bool
	{
		var isCraftable:Bool = false;
		var ownedByCount:Map<String, Int> = new Map<String, Int>();

		var item:Item;
		for(item in ownedItems)
		{
			var itemName:String = item.getName();
			if(ownedByCount.get(itemName) == null)
			{
				ownedByCount.set(itemName, 1);
			}
			else
			{
				ownedByCount.set(itemName, ownedByCount.get(itemName) + 1);
			}
		}

		return compareWithRequiredItems(requiredItems, ownedByCount);
	}

	private function compareWithRequiredItems(required:Map<String, Int>, owned:Map<String, Int>):Bool
	{
		var iterator:Iterator<String> = required.keys();
		while(iterator.hasNext())
		{
			var key:String = iterator.next();

			//we have the item
			if(owned.get(key) != null)
			{
				//we have enough of them
				if(owned.get(key) >= required.get(key))
				{
					return true;
				}
				return false;
			}
			return false;
		}

		return true;
	}

	//im only setting the used items to consumed so you dont have to
	public function craft(ownedItems:Array<Item>):Void
	{
		var item:Item;
		for(item in ownedItems)
		{
			var key:String = item.getName();

			if(requiredItems.get(key) != null)
			{
				var count:Int = requiredItems.get(key);
				if(count > 0)
				{
					item.consumed = true;
					requiredItems.set(key, requiredItems.get(key) - 1);
				}
			}
		}
	}
}