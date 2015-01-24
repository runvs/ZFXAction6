import flixel.FlxObject;
import flixel.tile.FlxTile;

class Level extends FlxObject
{
	
	private var _grpEnemies:flixel.group.FlxTypedGroup<Enemy>;
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

	public function addPlayer(player:Player):Void
	{
		_player = player;
		_grpEnemies.add(new Enemy());
		_grpEnemies.members[0].setPosition(_player.x, _player.y);
	}

	public override function update():Void
	{	
		super.update();
		map.update();
		_grpEnemies.update();
		flixel.FlxG.collide(_grpEnemies, map);
		_grpEnemies.forEachAlive(checkEnemyVision);
	}
	
	public override function draw():Void
	{
		//trace ("draw");
		map.draw();
		_grpEnemies.draw();
	}

	private function checkEnemyVision(e:Enemy):Void
	{
	    if (map.ray(e.getMidpoint(), _player.getMidpoint()))
	    {
	        e.seesPlayer = true;
	        e.playerPos.copyFrom(_player.getMidpoint());
	    }
	    else
	        e.seesPlayer = false;
	}	
	
}