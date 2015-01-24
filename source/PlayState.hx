package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private var _level:Level;
	
	private var _player : Player;
	

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		_level = new Level(this, 5, 5);
		add(MapGenerator.generate(512, 512));
_		player = new Player();
		
		FlxG.camera.follow(_player, FlxCamera.STYLE_TOPDOWN, new FlxPoint(), 10);
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
		super.update();
		//_level.update();
		
		//_grpGraphicMap.visible = true;
		_player.update();
	}	

	override public function draw():Void
	{
		//_level.draw();	
		super.draw();
		_player.draw();
		
		_player.drawHealth();
	}
}