class MapGenerator
{
	public static function generateMapFromTree(tree:flixel.group.FlxTypedGroup<Leaf>):StringBuf
	{
		//we need to give every room a roomType and every hall a hallType
		//for now, we do it random
		var currentLeaf:Leaf;

		//so dirty...
		var listOfHalls:Array<flixel.util.FlxRect> = new Array<flixel.util.FlxRect>();
		var listOfRooms:Array<flixel.util.FlxRect> = new Array<flixel.util.FlxRect>();
		var listOfTypes:Array<Int> = new Array<Int>();
		//iterate over all leafes
		for(currentLeaf in tree)
		{
			//get current room
			var room:flixel.util.FlxRect = currentLeaf.room;
			if(room != null)
			{
				//roll type for room
				var roomType:Int = 3; //always type one - we will manually add a canteen (2) later
				//put the roomtype value into the "map"
				listOfRooms.push(room);
				listOfTypes.push(roomType);
			}

			var hall:flixel.util.FlxRect;
			if(currentLeaf.halls != null)
			{
				for(hall in currentLeaf.halls)
				{
					listOfHalls.push(hall);
				}				
			}
		}

		//generate the map string
		var mapString:StringBuf = new StringBuf();

		//really bad but hey i studied computer science twice!
		for(y in 0 ... tree.members[0].height)
		{
			for(x in 0 ... tree.members[0].width)
			{
				//check every room :(
				var type:Int = 0;
				//trace(x + ","+y);
				for(roomIndex in 0 ... listOfRooms.length)
				{
					var tmpRoom:flixel.util.FlxRect = listOfRooms[roomIndex];
					//trace(x + "," + y + " in: " + tmpRoom.x + ", " + tmpRoom.y + " - (" + tmpRoom.width + ", " + tmpRoom.height +")");
					if(isInRoom(x, y, tmpRoom))
					{
						type = listOfTypes[roomIndex];
						//trace("yay");
						break;
					}
				}

				var tmpHall:flixel.util.FlxRect;
				for(tmpHall in listOfHalls)
				{
					if(isInHall(x, y, tmpHall))
					{
						if(type == 0)
						{
							type = 3;
						}
						break;
					}
				}

				mapString.add(Std.string(type));
				mapString.add(Std.string(","));
			}
			mapString.add(Std.string("\n"));
		}

		//trace(mapString);
		return mapString;
	}

	public static function isInHall(x:Int, y:Int, room:flixel.util.FlxRect):Bool
	{
		if(x >= room.x && x < room.x + room.width)
		{
			if(y >= room.y && y < room.y + room.height)
			{
				return true;
			}
		}

		return false;
	}

	public static function isInRoom(x:Int, y:Int, room:flixel.util.FlxRect):Bool
	{
		if(x > room.x && x <= room.x + room.width)
		{
			if(y > room.y && y <= room.y + room.height)
			{
				return true;
			}
		}

		return false;
	}


	//this function simply generates a list of rooms and connecting floors
	//you can add this with a list of desired rooms in a funtion im going to write right away
	public static function generateTree(mapSizeX:Int, mapSizeY:Int):flixel.group.FlxTypedGroup<Leaf>
	{
		var tree:flixel.group.FlxTypedGroup<Leaf> = new flixel.group.FlxTypedGroup<Leaf>();
		var root:Leaf = new Leaf(0, 0, mapSizeX, mapSizeY);

		tree.add(root);

  		var treeSplitted:Bool;
  		//these parameters will become changeable
		var splitChance:Float = 0.75;
		var MAX_LEAF_SIZE:Int = 12;

		do
		{
			var currentLeaf:Leaf;
			treeSplitted = false;
			for(currentLeaf in tree)
			{
		        if (currentLeaf.leftChild == null && currentLeaf.rightChild == null) // if this Leaf is not already split...
		        {
		            // if this Leaf is too big, or splitChance percent chance...
		            if (currentLeaf.width > MAX_LEAF_SIZE || currentLeaf.height > MAX_LEAF_SIZE || flixel.util.FlxRandom.chanceRoll(splitChance))
		            {
		                if (currentLeaf.split()) // split the Leaf!
		                {
		                    // if we did split, push the child leafs to the Vector so we can loop into them next
		                    tree.add(currentLeaf.leftChild);
		                    tree.add(currentLeaf.rightChild);
		                    treeSplitted = true;
		                }
		            }
		        }				
			}
		}
		while(treeSplitted);		

		root.createRooms();

		return tree;
	}

	    //returns the number of rooms in the tree with this leaf 
    //as root
    public static function numberOfRooms(tree:flixel.group.FlxTypedGroup<Leaf>):Int
    {
    	var currentLeaf:Leaf;
		var roomCount:Int = 0;

		for(currentLeaf in tree)
    	{
    		if(currentLeaf.room != null)
    		{
    			roomCount++;
    		}

    	}
    	return roomCount;
    }

    //this is the original api do not use it
	public static function generate(sizeX:Int, sizeY:Int):flixel.group.FlxGroup
	{
		var _mapData:flash.display.BitmapData;		// our map Data - we draw our map here to be turned into a tilemap later
		var _grpGraphicMap:flixel.group.FlxGroup;	// group for holding the map sprite, so it stays behind the UI elements	
		
		_mapData = new flash.display.BitmapData(sizeX, sizeY, false, 0xff000000);
		_grpGraphicMap =  new flixel.group.FlxGroup();

		var MAX_LEAF_SIZE:Int = 12;
		 
		var _leafs:flixel.group.FlxTypedGroup<Leaf> = new flixel.group.FlxTypedGroup<Leaf>();
		 
		var l:Leaf; // helper Leaf
		 
		// first, create a Leaf to be the 'root' of all Leafs.
		var root:Leaf = new Leaf(0, 0, sizeX, sizeY);
		_leafs.add(root);
		 
		var did_split:Bool = true;
		// we loop through every Leaf in our Vector over and over again, until no more Leafs can be split.
		while (did_split)
		{
		    did_split = false;
		    for (l in _leafs)
		    {
		        if (l.leftChild == null && l.rightChild == null) // if this Leaf is not already split...
		        {
		            // if this Leaf is too big, or 75% chance...
		            if (l.width > MAX_LEAF_SIZE || l.height > MAX_LEAF_SIZE || flixel.util.FlxRandom.float() > 0.25)
		            {
		                if (l.split()) // split the Leaf!
		                {
		                    // if we did split, push the child leafs to the Vector so we can loop into them next
		                    _leafs.add(l.leftChild);
		                    _leafs.add(l.rightChild);
		                    did_split = true;
		                }
		            }
		        }
		    }
		}	
		
		// next, iterate through each Leaf and create a room in each one.
		root.createRooms();	

		for(l in _leafs)
		{
			// then we draw the room and hallway if it exists
			if (l.room != null)
			{
				var flashRect:flash.geom.Rectangle = new flash.geom.Rectangle(l.room.x, l.room.y, l.room.width, l.room.height);
				_mapData.fillRect(flashRect, flixel.util.FlxColor.WHITE);
			}
			
			if (l.halls != null && l.halls.length > 0)
			{
				for(r in l.halls)
				{
					var flashRect:flash.geom.Rectangle = new flash.geom.Rectangle(r.x, r.y, r.width, r.height);
					_mapData.fillRect(flashRect, flixel.util.FlxColor.WHITE);
				}
			}
		}
		var _sprMap:flixel.FlxSprite;
			// We need to create a sprite to display our Map - it will be scaled up to fill the screen.
		// our map Sprite will be the size of or finished tileMap/tilesize.
		_sprMap = new flixel.FlxSprite();
		_sprMap.makeGraphic(100, 75, 0x0);
		_sprMap.scale.x = 8;
		_sprMap.scale.y = 8;	
		_grpGraphicMap.add(_sprMap);
		// make our map Sprite's pixels a copy of our map Data BitmapData. Tell flixel the sprite is 'dirty' (so it flushes the cache for that sprite)
		_sprMap.pixels = _mapData.clone();
		_sprMap.dirty = true;

		return _grpGraphicMap;
	}	
}