package ;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;

/**
 * ...
 * @author 
 */
class BattleSystem extends FlxObject
{

	private var _awaitInput : Bool;
	
	private var _background : FlxSprite;
	
	private var _btnAttack : FlxButton;
	private var _btnDefend : FlxButton;
	private var _btnSpecial : FlxButton;
	private var _btnFlee : FlxButton;
	private var _btnHeal : FlxButton;
	
	private var _playerHealth : FlxSprite;
	private var _enemyHealth : FlxSprite;
	private var _healthBackground1 : FlxSprite;
	private var _healthBackground2 : FlxSprite;
	
	private var _playerProperties : FightProperties;
	private var _enemyProperties : FightProperties;
	
	private var _playerSprite : FlxSprite;
	
	private var _enemySprite : FlxSprite;
	private var _player:Player;
	private var _enemy:Enemy;
	
	public var _lostBattle : Bool = false;
	
	private var _infoString : FlxText;
	private var _dropString : FlxText;
	
	
	private var _itemGenerator:ItemGenerator;
	
	private var _hit1Sound : FlxSound;
	private var _hit2Sound : FlxSound;
	private var _pickUpSound : FlxSound;
	private var _fleeFailSound : FlxSound;
	private var _fleeSuccessSound : FlxSound;
	private var _evadeSound : FlxSound;
	
	private var _battleWon : Bool;
	
	
	public function new() 
	{
		super();
		
		_awaitInput = true;
		active = false;
		_lostBattle = false;
		
		_background = new FlxSprite();
		_background.makeGraphic(600, 400, FlxColorUtil.makeFromARGB(1.0, 118, 66, 138));
		_background.setPosition(100, 100);
		_background.origin.set();
		_background.scrollFactor = new FlxPoint(0, 0);
		
		_btnAttack = new FlxButton(110, 450, "[A]ttack", PlayerAttack);
		_btnAttack.set_width( 130 );
		_btnAttack.scrollFactor = new FlxPoint(0, 0);
		
		_btnSpecial = new FlxButton(260, 450, "[S]pcial", PlayerSpecial);
		_btnSpecial.set_width( 130 );
		_btnSpecial.scrollFactor = new FlxPoint(0, 0);
		
		_btnDefend = new FlxButton(410, 450, "[D]efend", PlayerDefend);
		_btnDefend.set_width( 130 );
		_btnDefend.scrollFactor = new FlxPoint(0, 0);
		
		_btnFlee = new FlxButton(560, 450, "[F]lee", PlayerFlee);
		_btnFlee.set_width( 130 );
		_btnFlee.scrollFactor = new FlxPoint(0, 0);
		
		_btnHeal = new FlxButton( 110 , 475, "Hea[l]", PlayerHeal);
		_btnHeal.scrollFactor.set();
		
		_playerSprite = new FlxSprite();
		_playerSprite.loadGraphic(AssetPaths.player__png, true, 32, 32);
		_playerSprite.animation.add("walkright", [0, 1], 5, true);
		_playerSprite.animation.play("walkright");
		_playerSprite.scale.set(3, 3);
		_playerSprite.offset.set(2, 2);
		_playerSprite.origin.set(2, 2);
		_playerSprite.scrollFactor = new FlxPoint();
		_playerSprite.setPosition(200, 300);
		
		_enemySprite = new FlxSprite();
		_enemySprite.loadGraphic(AssetPaths.player__png, true, 32, 32);
		_enemySprite.animation.add("walkright", [0, 1], 5, true);
		_enemySprite.animation.play("walkright");
		_enemySprite.scale.set(3, 3);
		_enemySprite.offset.set(2, 2);
		_enemySprite.origin.set(2, 2);
		_enemySprite.scrollFactor = new FlxPoint();
		_enemySprite.setPosition(500, 200);
		
		_playerHealth = new FlxSprite();
		_playerHealth.makeGraphic( 150, 25, FlxColorUtil.makeFromARGB(1, 172 , 50, 50));
		_playerHealth.origin.set(0, 12);
		_playerHealth.setPosition(150, 400);
		_playerHealth.scrollFactor.set();
		
		_enemyHealth = new FlxSprite();
		_enemyHealth.makeGraphic( 150, 25, FlxColorUtil.makeFromARGB(1, 172 , 50, 50));
		_enemyHealth.origin.set(150, 12);
		_enemyHealth.setPosition(500, 150);
		_enemyHealth.scrollFactor.set();
		
		_healthBackground1 = new FlxSprite();
		_healthBackground1.makeGraphic( 154, 29, FlxColorUtil.makeFromARGB(1, 10 , 10, 10));
		_healthBackground1.origin.set(154, 29);
		_healthBackground1.setPosition(498, 148);
		_healthBackground1.scrollFactor.set();
		
		_healthBackground2 = new FlxSprite();
		_healthBackground2.makeGraphic( 154, 29, FlxColorUtil.makeFromARGB(1, 10 , 10, 10));
		_healthBackground2.origin.set(0, 12);
		_healthBackground2.setPosition(148, 398);
		_healthBackground2.scrollFactor.set();
		
		_infoString = new FlxText(0, 0, 200, "", 24);
		_infoString.scrollFactor.set();
		_infoString.alpha = 0;
		
		
		_dropString = new FlxText(300, 300, 200, "", 24);
		_dropString.scrollFactor.set();
		_dropString.alpha = 0;
		
		_hit1Sound = new  FlxSound();
		_hit2Sound = new  FlxSound();
		_pickUpSound = new FlxSound();
		_fleeFailSound = new FlxSound();
		_fleeSuccessSound = new FlxSound ();
		_evadeSound = new FlxSound();
		
		#if flash
        _hit1Sound = FlxG.sound.load(AssetPaths.hit__mp3, 0.25, false, false , false );
		_hit2Sound = FlxG.sound.load(AssetPaths.hit2__mp3, 0.25, false, false , false );
		_pickUpSound = FlxG.sound.load(AssetPaths.pickup__mp3, 0.25, false, false , false );
		_fleeFailSound = FlxG.sound.load(AssetPaths.fleefail__mp3, 0.25, false, false , false );
		_fleeSuccessSound = FlxG.sound.load(AssetPaths.fleesuccess__mp3, 0.25, false, false , false );
		_evadeSound = FlxG.sound.load(AssetPaths.evade__mp3, 0.25, false, false , false );
        #else
        _hit1Sound = FlxG.sound.load(AssetPaths.hit__ogg, 0.25 , false, false , false);
		_hit2Sound = FlxG.sound.load(AssetPaths.hit2__ogg, 0.25, false, false , false );
		_pickUpSound = FlxG.sound.load(AssetPaths.pickup__ogg, 0.25, false, false , false );
		_fleeFailSound = FlxG.sound.load(AssetPaths.fleefail__ogg, 0.25, false, false , false );
		_fleeSuccessSound = FlxG.sound.load(AssetPaths.fleesuccess__ogg, 0.25, false, false , false );
		_evadeSound = FlxG.sound.load(AssetPaths.evade__ogg, 0.25, false, false , false );
        #end
	}
	
	private function ShowInfoString (s : String, onPlayer:Bool) : Void 
	{
		if (onPlayer)
		{
			_infoString.setPosition(250, 225);
		}
		else 
		{
			_infoString.setPosition(500, 125);
		}
		_infoString.text = s;
		_infoString.alpha = 1.0;
		FlxTween.tween(_infoString, { y : y - 100, alpha : 0.0 }, 1.0);
	}
	
	private function ShowDropString (s : String) : Void 
	{
		
		_dropString.setPosition(250, 225);
		_dropString.text = s;
		_dropString.alpha = 1.0;
		FlxTween.tween(_dropString, { y : y - 100, alpha : 0.0 }, 1.0, {startDelay: 1});
	}
	
	public override function update () : Void 
	{
		getInput();
	
		_background.update();
		_btnAttack.update();
		_btnDefend.update();
		_btnSpecial.update();
		_btnFlee.update();
		_btnHeal.update();

		_playerSprite.update();
		_enemySprite.update();
		
		ScaleHealthBars();

		CheckActorHealth();
		_infoString.update();
		
		_btnSpecial.text = "[S]pecial (" + (_playerProperties.SpecialAttackNeeded - _playerProperties.SpecialAttackCollected) + ")";
	}
	
	private function LooseBattle() : Void 
	{
		// you loose
		active = false;
		_lostBattle = true;
	}
	
	private function WinBattle () : Void 
	{
		_battleWon = true;
		// drop items
		_lostBattle = false;
		_enemy.alive = false;

		var item:Item = _itemGenerator.generateDrop(0);
		//trace(item);

		
		_player._collectedItems.push(item);
		
		ShowDropString("Dropped " + item.getName() + "\n" + item.getInfo());
		var t:FlxTimer = new FlxTimer(2.0, function (t:FlxTimer) : Void  { active = false; } );
		
	}
	
	private function getInput() : Void 
	{
		if ( FlxG.keys.justPressed.A)
		{
			PlayerAttack();
		}
		else if ( FlxG.keys.justPressed.D)
		{
			PlayerDefend();
		}
		else if ( FlxG.keys.justPressed.S)
		{
			PlayerSpecial();
		}
		else if ( FlxG.keys.justPressed.F)
		{
			PlayerFlee();
		}
		else if (FlxG.keys.justPressed.L)
		{
			PlayerHeal();
		}
	}
	
	
	private function PlayerAttack() : Void 
	{
		if (_awaitInput)
		{
			BlockGUI();
			FlxTween.tween(_playerSprite, { x : _enemySprite.x, y:_enemySprite.y }, 0.75, { ease : FlxEase.bounceOut, 
			complete : function (t:FlxTween) : Void 
			{ 
				FlxTween.tween(_playerSprite, { x : 200, y: 300 }, 0.5 ); 
				var hasHit : Int = _playerProperties.DoAttack(_enemyProperties);
				
				if (hasHit != 0)
				{
					ShowInfoString(Std.string(hasHit), false);
					_hit1Sound.play();
				}
				else 
				{
					ShowInfoString("Evade", false);
					_evadeSound.play();
				}
			} 
			} );
				
			var  t: FlxTimer  = new FlxTimer(1.25, function (t:FlxTimer) : Void 
			{
				if (_enemyProperties.HealthCurrent > 0)
				{
					DoEnemyAction();
				}
			});
		}
	}
	
	public function DoEnemyAction() : Void 
	{
		_playerProperties.DoAddSpecial();
		BlockGUI();
		FlxTween.tween(_enemySprite, { x : _playerSprite.x, y:_playerSprite.y }, 0.75, { ease : FlxEase.bounceOut, 
		complete : function (t:FlxTween) : Void 
		{ 
			FlxTween.tween(_enemySprite, { x : 500, y: 200 }, 0.5 ); 
			var hasHit : Int = _enemyProperties.DoAttack(_playerProperties);
				
				if (hasHit != 0)
				{
					ShowInfoString(Std.string(hasHit), true);
					_hit2Sound.play();
				}
				else 
				{
					ShowInfoString("Evade", true);
					_evadeSound.play();
				}
		} 
		} );
	}
		
	private function PlayerDefend() : Void 
	{
		if (_awaitInput)
		{
			DoEnemyAction();
			BlockGUI();
		}
	}
	
	private function PlayerSpecial() : Void 
	{
		if (_awaitInput)
		{
			if (_playerProperties.SpecialAttackCollected >= _playerProperties.SpecialAttackNeeded)
			{
				
				FlxTween.tween(_playerSprite, { x : _enemySprite.x, y:_enemySprite.y }, 0.75, { ease : FlxEase.bounceOut, 
			complete : function (t:FlxTween) : Void 
			{ 
				FlxTween.tween(_playerSprite, { x : 200, y: 300 }, 0.5 ); 
				var hasHit : Int = _playerProperties.DoSpecialAttack(_enemyProperties);
				
				if (hasHit != 0)
				{
					ShowInfoString(Std.string(hasHit), false);
					_hit1Sound.play();
				}
				else 
				{
					ShowInfoString("Evade", false);
					_evadeSound.play();
				}
			} 
			} );
				
			var  t: FlxTimer  = new FlxTimer(1.25, function (t:FlxTimer) : Void 
			{
				if (_enemyProperties.HealthCurrent > 0)
				{
					DoEnemyAction();
				}
			});
				
				
				
				BlockGUI();
				DoEnemyAction();
			}
			
		}
	}
		
	
	private function PlayerFlee() : Void
	{
		if (_awaitInput)
		{
			DoEnemyAction();
			BlockGUI();
			var  t: FlxTimer  = new FlxTimer(1.75, function (t:FlxTimer) : Void 
			{
				// wait until the enemy's attack is finished, then try to flee 
				
				FlxTween.tween(_playerSprite, { x: 100 } , 0.5);
				
				if (_playerProperties.DoFlee(_enemyProperties))
				{
					
					ShowInfoString("Flee", true);
					var t: FlxTimer = new FlxTimer(0.5, function(t:FlxTimer) : Void { active = false; _fleeSuccessSound.play(); } );
					
				}
				else
				{
					ShowInfoString("No Escape", true);
					
					var t: FlxTimer = new FlxTimer(0.5, function (t: FlxTimer) : Void 
					{
						_fleeSuccessSound.play();
						FlxTween.tween(_playerSprite, { x: 200 } , 0.25);
					});
					BlockGUI();
				}
			});
		}
	}
	
	function PlayerHeal () : Void 
	{
		if (_player._hpCurrent > 0 )
		{
			_player.ReduceHP();
			_player._fightingProperties.HealthCurrent = _playerProperties.HealthMax;
			_playerProperties.HealthCurrent = _playerProperties.HealthMax;
		}
	}
	
	
	function ScaleHealthBars():Void 
	{
		_playerHealth.scale.x = ((_playerProperties.HealthCurrent > 0) ?  _playerProperties.HealthCurrent / _playerProperties.HealthMax : 0);
		_enemyHealth.scale.x = ((_enemyProperties.HealthCurrent > 0) ?_enemyProperties.HealthCurrent / _enemyProperties.HealthMax : 0 );
	}
	
	function BlockGUI():Void 
	{
		_awaitInput = false;
		var t : FlxTimer = new FlxTimer(1.5, function (t:FlxTimer) : Void { _awaitInput = true; } );
	}
	
	function CheckActorHealth():Void 
	{
		if (_awaitInput)
		{
			if (_playerProperties.HealthCurrent <= 0)
			{
				LooseBattle();
			}
			else if (_enemyProperties.HealthCurrent <= 0)
			{
				if (!_battleWon)
				{
					WinBattle();
				}
			}
		}
	}
	
	public override function draw () : Void 
	{
		if (active)
		{
			_background.draw();
			
			_enemySprite.draw();
			_playerSprite.draw();
			
			
			_healthBackground1.draw();
			_healthBackground2.draw();
			_playerHealth.draw();
			_enemyHealth.draw();
			
			_btnAttack.draw();
			_btnDefend.draw();
			_btnSpecial.draw();
			_btnFlee.draw();
			_btnHeal.draw();
			
			_infoString.draw();
			_dropString.draw();
		}
	}
	
	public function StartBattle ( e : Enemy, p:Player, itemGenerator:ItemGenerator) : Void 
	{
		active = true;
		_player = p;
		_enemy = e;
		_playerProperties = p.GetFightProperties();
		_enemyProperties = e.GetFightProperties();
		_itemGenerator = itemGenerator;
		_battleWon = false;
	}
	
}