class Enemy extends flixel.FlxSprite
{
	public var speed:Float = 80;
	private var _brain:StupidEnemyBrain;
	private var _idleTmr:Float;
	private var _moveDir:Float;
	public var seesPlayer:Bool = false;
	private var _fightingProperties:FightProperties;
	public var _chasePath:flixel.util.FlxPath;

	public function new()
	{
		super();
		_fightingProperties = new FightProperties();
		loadGraphic(AssetPaths.player__png, true, 32, 32);
		scale.set(0.5, 0.5);	
		offset.set(2,2);
		origin.set(2,2);
		width = 12;
		height = 12;

		_brain = new StupidEnemyBrain(idle);
		_idleTmr = 0;
		_chasePath = new flixel.util.FlxPath();	
	}

	public override function update():Void
	{
		super.update();
		_brain.update();
	}

	public function GetFightProperties() : FightProperties
	{
		return _fightingProperties;
	}	

	public function idle():Void
	{
	}


	public function chase():Void
	{
		trace("chase");
	}	
}