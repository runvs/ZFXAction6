package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

/**
 * ...
 * @author 
 */
class CutSceneIntro extends FlxState
{

	private var _text : FlxText;
	
	private var _text2 : FlxText;
	private var _text3 : FlxText;
	
	private var _sprite_ikea : FlxSprite;
	private var _sprite_plug : FlxSprite;
	
	public function new() 
	{
		super();
		
	}
	
	
	override public function create():Void
	{
		super.create();
		_sprite_ikea = new FlxSprite();
		_sprite_ikea.loadGraphic(AssetPaths.cut_intro__png, false, 100, 75);
		_sprite_ikea.scale.set(4, 4);
		_sprite_ikea.setPosition(400, 10);
		_sprite_ikea.origin.set();
		_sprite_ikea.alpha = 0;
		add(_sprite_ikea);
		
		_sprite_plug = new FlxSprite();
		_sprite_plug.loadGraphic(AssetPaths.cut_intro_plug__png, false, 100, 75);
		_sprite_plug.scale.set(4, 4);
		_sprite_plug.setPosition(400, 10);
		_sprite_plug.origin.set();
		_sprite_plug.alpha = 0;
		add(_sprite_plug);
				

		
		_text = new FlxText(25, 25, 350, "... After i got my new living room cupboard, everything seemed ready for assembly.", 32);
		_text.alpha = 0.0;
		FlxTween.tween(_text, { alpha:1.0 }, 1);
		add(_text);
		
		_text2 = new FlxText(25, 350, 750, "If not this stupid plug No. 101351 had been missing.", 32);
		_text2.alpha = 0.0;
		add(_text2);
		
				_text3 = new FlxText(25, 450, 750, "So I went to IKE to get one.", 32);
		_text3.alpha = 0.0;
		add(_text3);
		
		// fade in sprite_plug & text2
		FlxTween.tween(_sprite_plug, { alpha:1.0 }, 1, {startDelay : 4}); 
		FlxTween.tween(_text2, { alpha:1.0 }, 1, {startDelay : 4});

		// switch images, add text3
		FlxTween.tween(_sprite_plug, { alpha:0.0 }, 1, {startDelay : 7}); 
		FlxTween.tween(_sprite_ikea, { alpha:1.0 }, 1, { startDelay : 7 } );
		FlxTween.tween(_text3, { alpha:1.0 }, 1, { startDelay : 7 } );		
		
		var tEnd :FlxTimer = new FlxTimer(11, function (t:FlxTimer) : Void { StartGame(); } );
	}
	
	public override function update () : Void
	{
		super.update();
		
		if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE)
		{
			StartGame();
		}
	}
	
	public override function draw () : Void
	{
		super.draw();
	}
	
	function StartGame():Void 
	{
		FlxG.switchState(new PlayState());
	}
	
}