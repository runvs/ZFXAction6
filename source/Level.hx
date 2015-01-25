import flixel.FlxObject;
import flixel.tile.FlxTile;

class Level extends FlxObject
{
	
	public var _grpEnemies:flixel.group.FlxTypedGroup<Enemy>;
	private var _player:Player;

	public var map : flixel.tile.FlxTilemap;
	
	public function new(state:PlayState, sizeX:Int, sizeY:Int)
	{
		super();

		initializeLevel(sizeX, sizeY);
		_grpEnemies = new flixel.group.FlxTypedGroup<Enemy>();
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
<<<<<<< HEAD
		flixel.FlxG.collide(_grpEnemies, map);
		_grpEnemies.update();
=======
		_grpEnemies.update();
		if (flixel.FlxG.collide(map, _grpEnemies))
		{
			trace ("collide");
		}
		
>>>>>>> 8896358b0d7b6a97d758d4f3a04897374666b09e
		_grpEnemies.forEachAlive(checkEnemyVision);
	}

	public override function draw():Void
	{
		map.draw();
		_grpEnemies.draw();
	}

	private function checkEnemyVision(e:Enemy):Void
	{
		var pathToHero:Array<flixel.util.FlxPoint> = map.findPath(e.getMidpoint(), _player.getMidpoint(), false);
		
	    if (map.ray(e.getMidpoint(), _player.getMidpoint()) && pathToHero.length < 7)
	    {
	        e.seesPlayer = true;
	        e._chasePath.start(e, pathToHero, e.speed);
	    }
	    else
	    {
	        e.seesPlayer = false;	  
	    }
	}	
	
}