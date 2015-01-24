import flixel.FlxObject;
import flixel.tile.FlxTile;

class Level extends FlxObject
{
	
		
	public var map : flixel.tile.FlxTilemap;
	
	public function new(state:PlayState, sizeX:Int, sizeY:Int)
	{
		super();

		initializeLevel(sizeX, sizeY);
	}
	
	
	

	private function initializeLevel(sizeX:Int, sizeY:Int):Void
	{
			
		map = new flixel.tile.FlxTilemap();

		map.loadMap(MapGenerator.generateMapFromTree(MapGenerator.generateTree(32, 32)).toString(), AssetPaths.SpriteSheetA__png, 16, 16, 0, 0, 0);
		map.setTileProperties(0, FlxObject.ANY);
		map.setTileProperties(1, FlxObject.NONE);
		map.setTileProperties(2, FlxObject.NONE);
		map.setTileProperties(3, FlxObject.NONE);
		map.setTileProperties(4, FlxObject.NONE);
		map.setTileProperties(5, FlxObject.NONE);
		map.scale.set(1, 1);
	}

	public override function update():Void
	{
		super.update();
		map.update();
	}

	public override function draw():Void
	{
		map.draw();
	}
	
}