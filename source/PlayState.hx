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
	private var _levelList : Array<Level>;
	private var _currentLevelNumber : Int;
	
	private var _player : Player;

	private var _overlay : FlxSprite;
	private var _inLevelChange : Bool;
	
	private var _battleSystem : BattleSystem;
	public var _itemGenerator:ItemGenerator;
	
	private var _inventory : Inventory;
	
	 /* Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		_levelList = new Array<Level>();
		_itemGenerator = new ItemGenerator();
		_battleSystem = new BattleSystem();
		_player = new Player();

		_overlay = new FlxSprite();
		_overlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		_overlay.alpha = 1.0;
		_overlay.scrollFactor.set();
		
		_inLevelChange = false;
		
		spawnLevels(20);
		PlacePlayer();
		_inventory = new Inventory(_player);
		
		//lets go, tween in
		FlxG.camera.follow(_player, FlxCamera.STYLE_TOPDOWN, new FlxPoint(), 10);
		FlxTween.tween(_overlay, { alpha:0.0 }, 1.0);
		
		
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
		if (_battleSystem._lostBattle)
		{
			// you lost a battle
			EndGame();
		}
		
		_inventory.update();
	
		if (!_battleSystem.active)
		{
			super.update();
			
			_overlay.update();
			
			if (!_inLevelChange)
			{
				_player.update();
				_levelList[_currentLevelNumber].update();
			}
			
			_levelList[_currentLevelNumber]._grpEnemies.forEachAlive(function(e:Enemy):Void{flixel.FlxG.overlap(e, _player, StartFight);});
			
			FlxG.collide(_player, _levelList[_currentLevelNumber].map);

			CheckSpecialTiles();
		}
		else
		{
			_battleSystem.update();
		}	
	}	
	
	private function MoveLevelDown() : Void 
	{
		if(_currentLevelNumber >  20)
			return;

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
			FlxTween.tween(_overlay, { alpha:0.0 }, 1.0);
			_inLevelChange = false;
		}		
	}
	
	function spawnLevels(count:Int):Void
	{
		for(i in 0...count)
		{
			var level : Level = new Level(this, _player, 32, 32);
			_levelList.push(level);			
		}
		_currentLevelNumber = 0;
	}

	function PlacePlayer():Void 
	{
		for (i in 0 ... _levelList[_currentLevelNumber].map.widthInTiles)
		{
			for (j in 0 ... _levelList[_currentLevelNumber].map.heightInTiles)
			{
				if ( _levelList[_currentLevelNumber].map.getTile(i, j) != 0 && _levelList[_currentLevelNumber].map.getTile(i, j) != 1
					&& _levelList[_currentLevelNumber].map.getTile(i, j) != 2)
				{
					_player.setPosition(16 * i, 16 * j);
					return;
				}
			}
		}
	}
	
	function CheckSpecialTiles():Void 
	{
		if (!_inLevelChange)
		{
			// To 'close' the interior, black needs to be wall too, index 0.
			var px : Int = cast _player.x / 16;
			var py : Int = cast _player.y / 16;
			
			
			if (_levelList[_currentLevelNumber].map.getTile(px, py) == 1)
			{
				FlxTween.tween(_overlay, { alpha:1.0 }, 1.0);
				var t : FlxTimer = new FlxTimer(1.0, function (t:FlxTimer) : Void { MoveLevelDown();  } );
				_inLevelChange = true;
			}			
			if (_levelList[_currentLevelNumber].map.getTile(px, py) == 2)
			{
				if (_currentLevelNumber != 0)
				{
					FlxTween.tween(_overlay, { alpha:1.0 }, 1.0);
					_inLevelChange = true;
					var t : FlxTimer = new FlxTimer(1.0, function (t:FlxTimer) : Void { MoveLevelUp();  } );
				}
				else
				{
					//FlxG.switchState(new CutSceneNoEscape(this));
				}
			}		
			if (_levelList[_currentLevelNumber].map.getTile(px, py) == 3)
			{
				_player.RefillHP();
			}			
		}
	}
	
	public function EndGame():Void 
	{
		FlxTween.tween(_overlay, { alpha : 1.0 }, 1, {complete:function (t:FlxTween) : Void { FlxG.switchState(new MenuState());}});
	}

	override public function draw():Void
	{
		super.draw();
		_levelList[_currentLevelNumber].draw();
		_player.draw();
		_player.drawHealth();
		_battleSystem.draw();
		_inventory.draw();
		_overlay.draw();
	}
	
	public function StartFight (e:Enemy, p:Player) : Void 
	{
		trace ("startfight");
		_battleSystem.StartBattle(e, p, _itemGenerator);
	}
	
}