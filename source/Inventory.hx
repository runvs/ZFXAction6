package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.text.FlxText;
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
	

	public function new(player : Player) 
	{
		super();
		_player = player;
		
		_background = new FlxSprite();
		_background.makeGraphic(100, 400, FlxColorUtil.makeFromARGB(1.0, 118, 66, 138));
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
		
	}
	
	public override function update () : Void
	{
		MouseClick();
		
		_background.update();
		_item1.update();
		_item2.update();
		_item3.update();
		
		_text1.text = "CaddyLack\n" + "(" + Std.string(_blueprint1.getNumberOfCollectedItems(BluePrint.convertArrayToMap(_player._collectedItems))) + "/" + Std.string(_blueprint1.getNumberOfTotalItems()) + ")";
		_text2.text = "Hektar\n" + "(" + Std.string(_blueprint2.getNumberOfCollectedItems(BluePrint.convertArrayToMap(_player._collectedItems))) + "/" + Std.string(_blueprint2.getNumberOfTotalItems()) + ")";
		_text3.text = "Preiselbeeren\n" + "(" + Std.string(_blueprint3.getNumberOfCollectedItems(BluePrint.convertArrayToMap(_player._collectedItems))) + "/" + Std.string(_blueprint3.getNumberOfTotalItems()) + ")";
		
		_text1.update();
		_text2.update();
		_text3.update();
		trace (_text1.text);
		
		
		
		
	}
	
	private function Upgrade1 () : Void 
	{
		
	}
	
	private function Upgrade2 () : Void 
	{
		
	}
	private function Upgrade3 () : Void 
	{
		
	}
	
	function MouseClick():Void 
	{
		if (FlxG.mouse.justPressed)
		{
			if (_item1.overlapsPoint(FlxG.mouse))
			{
				Upgrade1();
			}
			else if (_item1.overlapsPoint(FlxG.mouse))
			{
				Upgrade2();
			}
			else if (_item1.overlapsPoint(FlxG.mouse))
			{
				Upgrade3();
			}		
		}
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

	}
	
}