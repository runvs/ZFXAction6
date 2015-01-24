import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxTypedGroup;
import flixel.tile.FlxTile;

class Level extends FlxObject
{
	
	private var _grpEnemies:flixel.group.FlxTypedGroup<Enemy>;
	private var _player:Player;

	public var map : flixel.tile.FlxTilemap;
	private var _state :PlayState;
	
	public function new(state:PlayState, sizeX:Int, sizeY:Int)
	{
		super();
	
		_state = state;
		
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
		
		_grpEnemies.forEachAlive(checkEnemyTouching);
		
		var newEnemyList : FlxTypedGroup<Enemy> = new FlxTypedGroup<Enemy>();
		_grpEnemies.forEach(function(p:Enemy) { if (p.alive) { newEnemyList.add(p); } else { p.destroy(); } } );
		_grpEnemies = newEnemyList;
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
	
	private function checkEnemyTouching (e:Enemy) : Void
	{
		FlxG.overlap(e, _player, StartFight);
		e.alive = false;
	}
	
	public function StartFight(e:Enemy, p:Player) : Void 
	{
		_state.StartFight(e);
	}
	
}