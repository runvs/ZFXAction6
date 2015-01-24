class Enemy extends flixel.FlxSprite
{
	private var _positionX:Float;
	private var _positionY:Float;

	var speed:Float = 80;
	private var _brain:StupidEnemyBrain;
	private var _idleTmr:Float;
	private var _moveDir:Float;
	public var seesPlayer:Bool = false;
	public var playerPos(default, null):flixel.util.FlxPoint;

	public function new()
	{
		super();

		loadGraphic(AssetPaths.player__png, true, 32, 32);
		scale.set(0.5, 0.5);	
		offset.set(2,2);
		origin.set(2,2);
		width = 12;
		height = 12;
		
		_brain = new StupidEnemyBrain(idle);
		_idleTmr = 0;
		playerPos = flixel.util.FlxPoint.get();	
	}

	public override function draw():Void
	{
		super.draw();
	}

	public override function update():Void
	{
		super.update();
		_brain.update();
	}

	public function idle():Void
	{
		trace("idle");
	    if (seesPlayer)
	    {
	        _brain.activeState = chase;
	    }
	    else if (_idleTmr <= 0)
	    {
	        if (flixel.util.FlxRandom.chanceRoll(1))
	        {
	            _moveDir = -1;
	            velocity.x = velocity.y = 0;
	        }
	        else
	        {
	            _moveDir = flixel.util.FlxRandom.intRanged(0, 8) * 45;
	            flixel.util.FlxAngle.rotatePoint(speed * .5, 0, 0, 0, _moveDir, velocity);
	        }
	        _idleTmr = flixel.util.FlxRandom.intRanged(1, 4);    
	    }
	    else
	    {
	        _idleTmr -= flixel.FlxG.elapsed;
	    }
	}

	public function chase():Void
	{
		trace("chase");
	    if (!seesPlayer)
	    {
	        _brain.activeState = idle;
	    }
	    else
	    {
	    	trace(playerPos);
	        flixel.util.FlxVelocity.moveTowardsPoint(this, playerPos, Std.int(speed));
	    }
	}	
}