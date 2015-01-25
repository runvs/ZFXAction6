package ;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

/**
 * ...
 * @author 
 */
class CutSceneNoEscape extends FlxState
{
	private var _text : FlxText;
	private var _state : PlayState;
	public function new(state:PlayState ) 
	{
		super();
		_state = state;
		
		_text = new FlxText (25, 25, 750, "I cannot leave without Plug 101351");
		add(_text);
		
		var t : FlxTimer = new FlxTimer(4, function (t:FlxTimer) { FlxG.switchState(_state); } );
	}
	
	public override function update () : Void
	{
		if (FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.ENTER)
		{
			FlxG.switchState(_state);
		}
	}
	
}