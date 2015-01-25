package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;
import flixel.util.FlxVector;

/**
 * ...
 * @author 
 */
class Player extends FlxObject
{

	public var _collectedItems:Array<Item>;

	public var _sprite : FlxSprite;
	
	private var _hpFull : FlxSprite;
	private var _hpEmpty : FlxSprite;
	
	private var _hpMax : Int;
	private var _hpCurrent : Int;
	
	private var _healthOffset : FlxTypedGroup<FlxSprite>;
	
	private var _totalTime : Float;
	
	private var _timer : FlxTimer;

	private var _fightingProperties:FightProperties;
	
	public function new() 
	{
		super();
	
		_fightingProperties = new FightProperties();
		_sprite = new FlxSprite();
		_sprite.loadGraphic(AssetPaths.player__png, true, 32, 32);
		_sprite.animation.add("walkright", [0, 1], 5, true);
		_sprite.animation.add("idle", [0], 5, true);
		_sprite.animation.play("idle");
		_sprite.scale.set(0.5, 0.5);
		_sprite.offset.set(2,2);
		_sprite.origin.set(2,2);
		width = 12;
		height = 12;
		
		_hpEmpty = new FlxSprite();
		_hpEmpty.loadGraphic(AssetPaths.hp_empty__png, false, 16, 16);
		_hpEmpty.scale.set(4, 4);
		_hpEmpty.scrollFactor.set();
		
		_hpFull = new FlxSprite();
		_hpFull.loadGraphic(AssetPaths.hp_full__png, false, 16, 16);
		_hpFull.scale.set(4, 4);
		_hpFull.scrollFactor.set();
		
		_hpCurrent = _hpMax = 5;
		
		_healthOffset = new FlxTypedGroup<FlxSprite>();
		_healthOffset.add(new FlxSprite());
		_healthOffset.add(new FlxSprite());
		_healthOffset.add(new FlxSprite());
		_healthOffset.add(new FlxSprite());
		_healthOffset.add(new FlxSprite());
		
		_totalTime = 0;
		
		_collectedItems = new Array<Item>();				
		_timer = new FlxTimer(GameProperties.PlayerReduceKoetbullaTime, TriggerReduceKoetbulla, 0);

		_fightingProperties.AttackDamage = 10;
	}
	
	public function TriggerReduceKoetbulla (t:FlxTimer):Void
	{
		trace ("reduce");
		ReduceHP();
	}
	
	public override function update():Void
	{
		super.update();
		_sprite.update();
	
		DoMovement();
		DoKoetbullaWobble();

		var item:Item;
		for(item in _collectedItems)
		{
			item.apply(this);
		}
		//trace(_fightingProperties.AttackDamage);
	}
	
	public override function draw():Void
	{
		_sprite.draw();
	}
	
	public function drawHealth() : Void 
	{
		//trace ("player:drawhealth");
		for (i in 0 ... _hpCurrent)
		{
			_hpFull.x = 20 + i * 64 + _healthOffset.members[i].x;
			_hpFull.y = 550 + _healthOffset.members[i].y;
			_hpFull.draw();
		}
		
		for (i in _hpCurrent ... _hpMax)
		{
			_hpEmpty.x = 20 + i * 64 + _healthOffset.members[i].x;
			_hpEmpty.y = 550 + _healthOffset.members[i].y;
			_hpEmpty.draw();
		}
	}
	
	function DoMovement():Void 
	{
		var up:Bool = FlxG.keys.anyPressed(["W", "UP"]);
		var down:Bool = FlxG.keys.anyPressed(["S", "DOWN"]);
		var left:Bool = FlxG.keys.anyPressed(["A", "LEFT"]);
		var right:Bool = FlxG.keys.anyPressed(["D", "RIGHT"]);
		
		if (left)
		{
			//velocity.x -= GameProperties.PlayerMovementVelocityAdd / FlxG.timeScale;
			x -= GameProperties.PlayerMovementVelocityAdd * FlxG.elapsed;
		}
		else if (right)
		{
			//velocity.x += GameProperties.PlayerMovementVelocityAdd / FlxG.timeScale;
			x += GameProperties.PlayerMovementVelocityAdd * FlxG.elapsed;
			_sprite.animation.play("walkright");
		}
		else if (up)
		{
			//velocity.y -= GameProperties.PlayerMovementVelocityAdd / FlxG.timeScale;
			y -= GameProperties.PlayerMovementVelocityAdd * FlxG.elapsed;
		}
		else if (down)
		{
			//velocity.y += GameProperties.PlayerMovementVelocityAdd / FlxG.timeScale;
			y += GameProperties.PlayerMovementVelocityAdd * FlxG.elapsed;
		}
		else
		{
			_sprite.animation.play("idle");
		}
		
		var v : FlxVector = new FlxVector(velocity.x, velocity.y);
		
		_sprite.setPosition(x, y);
	}
	
	function DoKoetbullaWobble():Void 
	{
		_totalTime += FlxG.elapsed;
		for (j in 0 ... _healthOffset.length)
		{
			_healthOffset.members[j].x = Math.sin(1.5 * (_totalTime * Math.sqrt(j+2) + j)) * 3;
			_healthOffset.members[j].y = Math.sin(1.25 * (_totalTime + j)) * 5;
		}
	}
	
	public function GetFightProperties() : FightProperties
	{
		return _fightingProperties;
	}
	
	public function ReduceHP() : Void 
	{
		_hpCurrent -= 1;
	}
	
	public function RefillHP () : Void 
	{
		_hpCurrent = _hpMax;
	}
	
}