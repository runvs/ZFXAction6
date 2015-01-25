class Enemy extends flixel.FlxSprite
{
	public var speed:Float = 80;
	private var _brain:StupidEnemyBrain;
	private var _idleTmr:Float;
	private var _moveDir:Float;
	public var seesPlayer:Bool = false;
	private var _fightingProperties:FightProperties;
	public var _chasePath:flixel.util.FlxPath;

	public function new(level:Int)
	{
		super();
		_fightingProperties = new FightProperties();

		loadGraphic(AssetPaths.Enemy__png, true, 32, 32);
		animation.add("right", [0, 1], 5, true);
		animation.add("left", [3, 4], 5, true);
		animation.add("down", [0, 1], 5, true);
		animation.add("up", [5, 6], 5, true);
		animation.add("idle", [0, 1, 2], 5, true);
		animation.play("idle");	

		DoBalancing(level);

		scale.set(0.5, 0.5);	
		offset.set(2,2);
		origin.set(2,2);
		width = 12;
		height = 12;

		_brain = new StupidEnemyBrain(idle);
		_idleTmr = 0;
		_chasePath = new flixel.util.FlxPath();	
	}

	public function DoBalancing (level:Int)
	{
		_fightingProperties.HealthCurrent = _fightingProperties.HealthMax = 4 + 1 * level;
		_fightingProperties.AttackDamage = 1 + Math.floor(1 * level);
		_fightingProperties.EvadeChance = 0.0125;
	}
	
	public override function update():Void
	{
		super.update();
		_brain.update();

		if (!_chasePath.finished && _chasePath.nodes != null) {
			if (_chasePath.angle == 0 || _chasePath.angle == 45 || _chasePath.angle == -45) {
				animation.play("up");
			}
			if (_chasePath.angle == 180 || _chasePath.angle == -135 || _chasePath.angle == 135) {
				animation.play("down");
			}
			if (_chasePath.angle == 90) {
				animation.play("right");
			}
			if (_chasePath.angle == -90) {
				animation.play("left");
			}
		} else {
			animation.play("idle");
		}	
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
		//trace("chase");
	}	
}