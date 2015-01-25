class BluePrint 
{
	public var requiredItems:Map<String, Int>;

	public function new()
	{
		requiredItems = new Map<String, Int>();
	}
	
	public var _infoString : String;
	
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
		for (i in 0 ... owned.length)
		{
			map.set(owned[i].getName(), 0);
		}
		for (i in 0 ... owned.length)
		{
			map.set(owned[i].getName(), map.get(owned[i].getName()) + 1);
			
		}
		
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

	public function getInfoString (owned : Map<String, Int>) : String
	{
		var s : String;
		var items : String = "";
		
		var iterator:Iterator<String> = requiredItems.keys();
		while(iterator.hasNext())
		{
			var key:String = iterator.next();
			var onelineString : String  = key + " (";
			
			//we have the item
			if(owned.get(key) != null)
			{
				onelineString += Std.string(owned.get(key));
			}
			else 
			{
				onelineString += " 0";
			}
			onelineString += " / " + Std.string(requiredItems.get(key)) + ")\n";
			items += onelineString;
		}
		
		s = _infoString + "\n" +  items;
		
		return s;
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