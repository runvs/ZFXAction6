class ExitGenerator
{

	public static function generateExitsForMap(map:flixel.tile.FlxTilemap, forbiddenList:Array<Int>):flixel.tile.FlxTilemap
	{
		var EXIT_UP_ID = 4;
		var EXIT_DOWN_ID = 4;

		var exitUpSet:Bool = false;
		var exitDownSet:Bool = false;

		var exitUpPosition:flixel.util.FlxPoint = new flixel.util.FlxPoint();
		var exitDownPosition:flixel.util.FlxPoint = new flixel.util.FlxPoint();

		//loop forever :D
		while(exitUpSet == false || exitDownSet == false)
		{
			for(y in 0...map.heightInTiles)
			{
				for(x in 0...map.widthInTiles)
				{
					var tileID:Int = map.getTile(x, y);

					if(forbiddenList.indexOf(tileID) == -1)
					{
						if(exitUpSet == false)
						{
							var chance:Float = flixel.util.FlxRandom.float();

							if(chance > 0.95)
							{
								trace("set exit at " + x + ", " + y);
								map.setTile(x, y, EXIT_UP_ID);
								exitUpSet = true;
								exitUpPosition.x = x;
								exitUpPosition.y = y;
								continue;
							}
						}

						if(exitUpSet == true && exitDownSet == false)
						{
							//distance should be at least 50
							exitDownPosition.x = x;
							exitDownPosition.y = y;
							if(exitDownPosition.distanceTo(exitUpPosition) < 25)
							{
								continue;
							}

							var chance:Float = flixel.util.FlxRandom.float();

							if(chance > 0.75)
							{
								trace("set exit at " + x + ", " + y);
								map.setTile(x, y, EXIT_DOWN_ID);
								exitDownSet = true;
								continue;
							}
						}	
					}
				}
			}	
		}

		return map;
	}
}