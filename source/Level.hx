import flixel.FlxObject;
import flixel.tile.FlxTile;

class Level extends FlxObject
{
	
	public var _grpEnemies:flixel.group.FlxTypedGroup<Enemy>;
	private var _player:Player;

	public var map : flixel.tile.FlxTilemap;
	public var _state:PlayState;

	public function new(state:PlayState, player:Player, sizeX:Int, sizeY:Int)
	{
		super();
		_state = state;
		_player = player;
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
		
		flixel.FlxG.collide(_grpEnemies, map);
		
		_grpEnemies.forEachAlive(function(e:Enemy):Void{e.update();});
		_grpEnemies.forEachAlive(checkEnemyVision);
	}

	public override function draw():Void
	{
		map.draw();
		_grpEnemies.forEachAlive(function(e:Enemy):Void{e.draw();});
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