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
	
	private var _maxLevels:Int;
	private var _inventory : Inventory;
	
	private var _tutorialText1 : FlxText;	// fuck you tutorial
	private var _tutorialText2 : FlxText;	//movement
	private var _tutorialText3 : FlxText;	// hotkeys
	private var _tutorialText4 : FlxText;	// koetbulla
	private var _tutorialText5 : FlxText;	// cantine
	private var _tutorialText6 : FlxText;	// you need to ascend nightly ikea
	private var _drawTutoral : Bool ;
	
	 /* Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		
		_levelList = new Array<Level>();
		_itemGenerator = new ItemGenerator();
		_battleSystem = new BattleSystem();
		_player = new Player();
		
		_drawTutoral = true;

		_overlay = new FlxSprite();
		_overlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		_overlay.alpha = 1.0;
		_overlay.scrollFactor.set();
		
		_inLevelChange = false;
		_maxLevels = 20;
		spawnLevels(_maxLevels);
		PlacePlayer();
		_inventory = new Inventory(_player);
		
		//lets go, tween in
		FlxG.camera.follow(_player, FlxCamera.STYLE_TOPDOWN, new FlxPoint(), 10);
		FlxTween.tween(_overlay, { alpha:0.0 }, 1.0);
	
		StartTutorial();
		
	}
	
	private function StartTutorial() : Void 
	{
		_tutorialText1 = new FlxText( 300, 200, 350, "Fuck [Y]ou Tutorial ", 32);
		_tutorialText1.alpha = 0;
		_tutorialText1.scrollFactor.set();
		
		FlxTween.tween(_tutorialText1,  { alpha : 1.0 }, 1, { complete : function(t: FlxTween) 
		{
			FlxTween.tween(_tutorialText1,  { alpha : 0.0 }, 1, { startDelay : 1.5 } );
		} } );
		
		_tutorialText2 = new  FlxText(300, 200, 350, "To Move, use WASD or Arrows", 32);
		_tutorialText2.alpha = 0;
		_tutorialText2.scrollFactor.set();
		
		FlxTween.tween(_tutorialText2,  { alpha : 1.0 }, 1, { complete : function(t: FlxTween) 
		{
			FlxTween.tween(_tutorialText2,  { alpha : 0.0 }, 1, { startDelay : 1.5 } );
		}, startDelay : 3.5 } );
		
		
		_tutorialText3 = new  FlxText(300, 200, 350, "Hotkeys are displayed in square brackets", 32);
		_tutorialText3.alpha = 0;
		_tutorialText3.scrollFactor.set();
		
		FlxTween.tween(_tutorialText3,  { alpha : 1.0 }, 1, { complete : function(t: FlxTween) 
		{
			FlxTween.tween(_tutorialText3,  { alpha : 0.0 }, 1, { startDelay : 1.5 } );
		}, startDelay : 7 } );
		
		_tutorialText4 = new  FlxText(300, 200, 350, "Your koetbulla (can heal you) drain over time & you get hungry.", 32);
		_tutorialText4.alpha = 0;
		_tutorialText4.scrollFactor.set();
		FlxTween.tween(_tutorialText4,  { alpha : 1.0 }, 1, { complete : function(t: FlxTween) 
		{
			FlxTween.tween(_tutorialText4,  { alpha : 0.0 }, 1, { startDelay : 1.5 } );
		}, startDelay : 10.5 } );
		
		_tutorialText5 = new  FlxText(300, 200, 350, "go to cafeteria (blue room) to refill", 32);
		_tutorialText5.alpha = 0;
		_tutorialText5.scrollFactor.set();
		FlxTween.tween(_tutorialText5,  { alpha : 1.0 }, 1, { complete : function(t: FlxTween) 
		{
			FlxTween.tween(_tutorialText5,  { alpha : 0.0 }, 1, { startDelay : 1.5 } );
		} , startDelay : 14 } );
		
		_tutorialText6 = new   FlxText(300, 200, 350, "You need to find the plug in the lower levels. Therefore ascend down!", 32);
		_tutorialText6.alpha = 0;
		_tutorialText6.scrollFactor.set();
		FlxTween.tween(_tutorialText6,  { alpha : 1.0 }, 1, { complete : function(t: FlxTween) 
		{
			FlxTween.tween(_tutorialText6,  { alpha : 0.0 }, 1, { startDelay : 1.5 } );
		} , startDelay : 17.5 } );
		
		_player.GetFightProperties().AttackDamage += 10000;
		_currentLevelNumber = 19;
		MoveLevelDown();	
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
		
		if (FlxG.keys.justPressed.Y)
		{
			_drawTutoral = false;
		}
		
		_tutorialText1.update();
		_tutorialText2.update();
		_tutorialText3.update();
		_tutorialText4.update();
		_tutorialText5.update();
		_tutorialText6.update();
		
		if (!_battleSystem.active)
		{
			trace(_currentLevelNumber);
			if(_currentLevelNumber == _maxLevels-1)
			{
				EndGame();
			}

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
			
			_inventory.UnBlock();
		}
		else
		{
			_battleSystem.update();
			_inventory.Block();
		}	
		//trace (_inventory._blockedInput);
	}	
	
	private function MoveLevelDown() : Void 
	{
		if(_currentLevelNumber > _maxLevels - 1)
		{
			return;
		}

		if(_currentLevelNumber == _maxLevels -1)
		{
			//we face hitler aka Billy of Doom
			var hitler:Enemy = new Enemy(_currentLevelNumber);
			_battleSystem.FightTheFuhrer();
			StartFight(hitler, _player);
		}
		else
		{
			_currentLevelNumber++;
			PlacePlayer();
			FlxTween.tween(_overlay, { alpha:0.0 }, 1.0);
			_inLevelChange = false;
		}
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
			var level : Level = new Level(this, _player, 32, 32, i);
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
			
			
			if (_levelList[_currentLevelNumber].map.getTile(px, py) == 7)
			{
				FlxTween.tween(_overlay, { alpha:1.0 }, 1.0);
				var t : FlxTimer = new FlxTimer(1.0, function (t:FlxTimer) : Void { MoveLevelDown();  } );
				_inLevelChange = true;
			}			
			if (_levelList[_currentLevelNumber].map.getTile(px, py) == 6)
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
			if (_levelList[_currentLevelNumber].map.getTile(px, py) == 2)
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
		
		if (_drawTutoral)
		{
			_tutorialText1.draw();
			_tutorialText2.draw();
			_tutorialText3.draw();
			_tutorialText4.draw();
			_tutorialText5.draw();
			_tutorialText6.draw();
		}
	}
	
	public function StartFight (e:Enemy, p:Player) : Void 
	{
		trace ("startfight");
		_battleSystem.StartBattle(e, p, _itemGenerator);
	}
	
}