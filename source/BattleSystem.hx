package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.util.FlxColorUtil;

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
	
	
	public function new(X:Float=0, Y:Float=0, Width:Float=0, Height:Float=0) 
	{
		super(X, Y, Width, Height);
		_awaitInput = true;
		
		_background = new FlxSprite();
		_background.makeGraphic(600, 400, FlxColorUtil.makeFromARGB(1.0, 118, 66, 138));
		_background.origin.set();
		_background.setPosition(100, 100);
		
		_btnAttack = new FlxButton(100, 500, "[A]ttack", PlayerAttack);
		_btnAttack.set_width( 130 );
		
		_btnSpecial = new FlxButton(400, 500, "[S]pcial", PlayerAttack);
		_btnSpecial.set_width( 130 );
				
		_btnDefend = new FlxButton(250, 500, "[D]efend", PlayerAttack);
		_btnDefend.set_width( 130 );
		
		_btnFlee = new FlxButton(550, 500, "[F]lee", PlayerAttack);
		_btnFlee.set_width( 130 );
	}
	
	public override function update () : Void 
	{
		getInput();
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
	}
	
	
	private function PlayerAttack() : Void 
	{
		
	}
		
	private function PlayerDefend() : Void 
	{
		
	}
	
	private function PlayerSpecial() : Void 
	{
		
	}
		
	private function PlayerFlee() : Void
	{
		
	}
	
	
	
	public override function draw () : Void 
	{
		_background.draw();
		_btnAttack.draw();
		_btnDefend.draw();
		_btnSpecial.draw();
		_btnFlee.draw();
	}
	
}