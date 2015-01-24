class MapGenerator
{

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
		var MAX_LEAF_SIZE:Int = 20;

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

		return tree;
	}

	public static function generateRooms(tree:Leaf)
	{
		tree.createRooms();
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

	public static function generate(sizeX:Int, sizeY:Int):flixel.group.FlxGroup
	{
		var _mapData:flash.display.BitmapData;		// our map Data - we draw our map here to be turned into a tilemap later
		var _grpGraphicMap:flixel.group.FlxGroup;	// group for holding the map sprite, so it stays behind the UI elements	
		
		_mapData = new flash.display.BitmapData(512, 512, false, 0xff000000);
		_grpGraphicMap =  new flixel.group.FlxGroup();

		var MAX_LEAF_SIZE:Int = 20;
		 
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
		_sprMap = new flixel.FlxSprite(flixel.FlxG.width / 2 - flixel.FlxG.width / 32, flixel.FlxG.height / 2 - flixel.FlxG.height / 32).makeGraphic(cast(flixel.FlxG.width / 16, Int), cast(flixel.FlxG.height / 16, Int), 0x0);
		_sprMap.scale.x = 16;
		_sprMap.scale.y = 16;	
		_grpGraphicMap.add(_sprMap);
		// make our map Sprite's pixels a copy of our map Data BitmapData. Tell flixel the sprite is 'dirty' (so it flushes the cache for that sprite)
		_sprMap.pixels = _mapData.clone();
		_sprMap.dirty = true;

		return _grpGraphicMap;
	}	
}