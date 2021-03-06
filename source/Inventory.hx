package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColorUtil;

/**
 * ...
 * @author 
 */
class Inventory extends FlxObject
{
	private var _player : Player;
	
	private var _background : FlxSprite;
	
	private var _item1 : FlxSprite;
	private var _item2 : FlxSprite;
	private var _item3 : FlxSprite;
	
	private var _text1 : FlxText;
	private var _text2 : FlxText;
	private var _text3 : FlxText;
	
	private var _blueprint1 : BluePrint;
	private var _blueprint2 : BluePrint;
	private var _blueprint3 : BluePrint;
	
	private var _infoText : FlxText;
	private var _infoBackground : FlxSprite;
	
	public var _blockedInput : Bool;

	public function new(player : Player) 
	{
		super();
		_player = player;
		
		_background = new FlxSprite();
		_background.makeGraphic(100, 400, FlxColorUtil.makeFromARGB(1.0,  0,0,0));
		_background.origin.set();
		_background.setPosition(700, 100);
		_background.scrollFactor.set();
		
		_item1 = new FlxSprite();
		_item1.loadGraphic(AssetPaths.Blueprint__png, false, 32, 32);
		_item1.scale.set(3, 3);
		_item1.scrollFactor.set();
		_item1.origin.set();
		_item1.updateHitbox();
		_item1.setPosition(700, 120);
		
		_item2 = new FlxSprite();
		_item2.loadGraphic(AssetPaths.Blueprint__png, false, 32, 32);
		_item2.scale.set(3, 3);
		_item2.scrollFactor.set();
		_item2.origin.set();
		_item2.updateHitbox();
		_item2.setPosition(700, 240);
		
		_item3 = new FlxSprite();
		_item3.loadGraphic(AssetPaths.Blueprint__png, false, 32, 32);
		_item3.scale.set(3, 3);
		_item3.scrollFactor.set();
		_item3.origin.set();
		_item3.updateHitbox();
		_item3.setPosition(700, 360);
		
		_text1 = new FlxText(700, 210, 120, "", 10);
		_text1.scrollFactor.set();
		
		_text2 = new FlxText(700, 330, 120, "", 10);
		_text2.scrollFactor.set();
		
		_text3 = new FlxText(700, 450, 120, "", 10);
		_text3.scrollFactor.set();
		
		_blueprint1 = new CaddyLack();	// defence
		_blueprint2 = new Hektar();		// attack
		_blueprint3 = new Preiselbeersauce();	// koetbulla
		
		_infoText = new FlxText(250, 200, 250, "", 16);
		_infoText.alpha = 0.0;
		_infoText.scrollFactor.set();
		
		_infoBackground = new FlxSprite();
		_infoBackground.makeGraphic(250, 200, FlxColorUtil.makeFromARGB(1.0, 0,0,0));
		_infoBackground.scrollFactor.set();
		_infoBackground.origin.set();
		_infoBackground.setPosition(250, 200);
		_infoBackground.alpha = 0.0;
		
		_blockedInput = false;
	}
	
	public function Block () : Void 
	{
		_blockedInput = true;
	}
	public function UnBlock () : Void 
	{
		_blockedInput = false;
	}
	
	public override function update () : Void
	{
	
		
		UpdateText();
		
		if (!_blockedInput)
		{
			
			if (FlxG.keys.justPressed.C)
			{
				_infoText.text = "CaddyLack\n" + _blueprint1.getInfoString(BluePrint.convertArrayToMap(_player._collectedItems));
				_infoText.alpha = 1.0;
				FlxTween.tween(_infoText, { alpha : 0.0 }, 0.5, { startDelay:2 } );
				_infoBackground.alpha = 1.0;
				FlxTween.tween(_infoBackground, { alpha : 0.0 }, 0.5, { startDelay:2 } );
				if (_blueprint1.isCraftable(_player._collectedItems))
				{
					_blueprint1.craft(_player._collectedItems, _player);
				}
				
				
				
			}
			if (FlxG.keys.justPressed.H)
			{
				_infoText.text = "Hektar\n"  + _blueprint2.getInfoString(BluePrint.convertArrayToMap(_player._collectedItems));
				_infoText.alpha = 1.0;
				FlxTween.tween(_infoText, { alpha : 0.0 }, 0.5, { startDelay:2 } );
				_infoBackground.alpha = 1.0;
				FlxTween.tween(_infoBackground, { alpha : 0.0 }, 0.5, { startDelay:2 } );
				if (_blueprint2.isCraftable(_player._collectedItems))
				{
					_blueprint2.craft(_player._collectedItems ,_player);
				}
			}
			if (FlxG.keys.justPressed.P)
			{
				_infoText.text = "Preiselbeersauce\n"  + _blueprint3.getInfoString(BluePrint.convertArrayToMap(_player._collectedItems));
				_infoText.alpha = 1.0;
				FlxTween.tween(_infoText, { alpha : 0.0 }, 0.5, { startDelay:2 } );
				_infoBackground.alpha = 1.0;
				FlxTween.tween(_infoBackground, { alpha : 0.0 }, 0.5, { startDelay:2 } );
				if (_blueprint3.isCraftable(_player._collectedItems))
				{
					_blueprint3.craft(_player._collectedItems, _player);
				}
				
			}
			
		}
		
		_background.update();
		_item1.update();
		_item2.update();
		_item3.update();
		
	}
	
	
	
	
	function UpdateText():Void 
	{
		_text1.text = "[C]addyLack\n" + "(" + Std.string(_blueprint1.getNumberOfCollectedItems(BluePrint.convertArrayToMap(_player._collectedItems))) + "/" + Std.string(_blueprint1.getNumberOfTotalItems()) + ")";
		_text2.text = "[H]ektar\n" + "(" + Std.string(_blueprint2.getNumberOfCollectedItems(BluePrint.convertArrayToMap(_player._collectedItems))) + "/" + Std.string(_blueprint2.getNumberOfTotalItems()) + ")";
		_text3.text = "[P]reiselbeeren\n" + "(" + Std.string(_blueprint3.getNumberOfCollectedItems(BluePrint.convertArrayToMap(_player._collectedItems))) + "/" + Std.string(_blueprint3.getNumberOfTotalItems()) + ")";
		
		_text1.update();
		_text2.update();
		_text3.update();	
		
		_infoText.update();
	}
	
	public override function draw () : Void
	{
		_background.draw();
		_item1.draw();
		_item2.draw();
		_item3.draw();
		
		_text1.draw();
		_text2.draw();
		_text3.draw();
	
		_infoBackground.draw();
		_infoText.draw();
	}
	
}