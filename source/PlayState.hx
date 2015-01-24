package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var _levelList : FlxTypedGroup<Level>;
	private var _currentLevelNumber : Int;
	
	private var _player : Player;

	private var _overlay : FlxSprite;
	private var _inLevelChange : Bool;
	
	private var _battleSystem : BattleSystem;

	
	 /* Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		_levelList = new FlxTypedGroup<Level>();
		_player = new Player();
		SpawnNextLevel();
		
		_currentLevelNumber = 0;
		
	
		
		PlacePlayer();
		FlxG.camera.follow(_player, FlxCamera.STYLE_TOPDOWN, new FlxPoint(), 10);
		_overlay = new FlxSprite();
		_overlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		_overlay.alpha = 1.0;
		_overlay.scrollFactor.set();
		
		FlxTween.tween(_overlay, { alpha:0.0 }, 1.0);
		_inLevelChange = false;
	
		_levelList.members[_currentLevelNumber].addPlayer(_player);
		FlxG.camera.follow(_player, FlxCamera.STYLE_TOPDOWN, new FlxPoint(), 10);
		_overlay.alpha = 1.0;
		
		FlxTween.tween(_overlay, { alpha:0.0 }, 1.0);
		_inLevelChange = false;
		
		_battleSystem = new BattleSystem(this);
		
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{

		if (!_battleSystem.active)
		{
			super.update();
			_levelList.members[_currentLevelNumber].update();
			_overlay.update();
			_player.update();
			
			FlxG.collide(_player, _levelList.members[_currentLevelNumber].map);
			
			LevelChange();
		}
		else
		{
			_battleSystem.update();
		}
		
		
	}	
	
	private function MoveLevelDown() : Void 
	{
		if (_currentLevelNumber + 1 >= _levelList.length)
		{
			SpawnNextLevel();
		}
		_currentLevelNumber++;
		PlacePlayer();
		FlxTween.tween(_overlay, { alpha:0.0 }, 1.0);
		_inLevelChange = false;
	}
	
	private function MoveLevelUp() : Void 
	{
		if (_currentLevelNumber != 0)
		{
			_currentLevelNumber--;
			PlacePlayer();
		}		
	}
	
	function SpawnNextLevel():Void 
	{
		var level : Level = new Level(this, 32, 32);
		_levelList.add(level);
	}
	
	function PlacePlayer():Void 
	{
		for (i in 0 ... _levelList.members[_currentLevelNumber].map.widthInTiles)
		{
			for (j in 0 ... _levelList.members[_currentLevelNumber].map.heightInTiles)
			{
				if ( _levelList.members[_currentLevelNumber].map.getTile(i, j) != 0)
				{
					_player.setPosition(16 * i, 16 * j);
					break;
				}
			}
		}
	}
	
	function LevelChange():Void 
	{
		if (!_inLevelChange)
		{
			// To 'close' the interior, black needs to be wall too, index 0.
			var px : Int = cast _player.x / 16;
			var py : Int = cast _player.y / 16;
			
			
			if (_levelList.members[_currentLevelNumber].map.getTile(px, py) == 1)
			{
				FlxTween.tween(_overlay, { alpha:1.0 }, 1.0);
				var t : FlxTimer = new FlxTimer(1.0, function (t:FlxTimer) : Void { MoveLevelDown();  } );
				//MoveLevelDown();
				_inLevelChange = true;
			}			
		}
	}

	override public function draw():Void
	{
		super.draw();
		_levelList.members[_currentLevelNumber].draw();
		_player.draw();
		_player.drawHealth();
		
		_battleSystem.draw();
		
		_overlay.draw();
		
	}
	
	public function StartFight (e:Enemy) : Void 
	{
		//_battleSystem.StartBattle(e, _player);
	}
	
}