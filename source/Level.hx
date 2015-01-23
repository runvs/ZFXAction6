import flixel.FlxObject;

class Level extends FlxObject
{
	private var _tileList:flixel.group.FlxTypedGroup<Tile>;

	public function new(state:PlayState, sizeX:Int, sizeY:Int)
	{
		super();

		initializeLevel(sizeX, sizeY);
	}

	private function initializeLevel(sizeX:Int, sizeY:Int):Void
	{
		_tileList = new flixel.group.FlxTypedGroup<Tile>();
		for (i in 0 ... sizeX) 
		{
			for (j in 0 ... sizeY) 
			{
				_tileList.add(new IdentityTile.IdentiyTile());
			}
		}
		//MapGenerator.generateMap();
	}

	public override function update():Void
	{
		super.update();
		trace("Level::update()");
	}

	public override function draw():Void
	{
		_tileList.forEach(function(t : Tile):Void{t.draw();});
	}
	
	public function getTile(x:Int, y:Int):Tile
	{
		return null;
	}
}