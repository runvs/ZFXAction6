package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
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
	private var _levelList : FlxTypedGroup<Level>;
	private var _currentLevelNumber : Int;
	
	private var _player : Player;


	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		try 
		{
			
		
		super.create();
		
		_levelList = new FlxTypedGroup<Level>();
		
		SpawnNextLevel();
		
		_currentLevelNumber = 0;
		
	
		_player = new Player();
		
		PlacePlayer();
		FlxG.camera.follow(_player, FlxCamera.STYLE_TOPDOWN, new FlxPoint(), 10);
			}
		catch (msg : String)
		{
			trace (msg);
		}
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
		try
		{
		super.update();
		_levelList.members[_currentLevelNumber].update();
		
		_player.update();
		FlxG.collide(_player, _levelList.members[_currentLevelNumber].map);
		
		
		// To 'close' the interior, black needs to be wall too, index 0.
		var px : Int = cast _player.x / 16;
		var py : Int = cast _player.y / 16;
		
		if (_levelList.members[_currentLevelNumber].map.getTile(px, py) == 1)
		{
			MoveLevelDown();
		}
		}
		catch (msg : String)
		{
			trace (msg);
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

	override public function draw():Void
	{
		super.draw();
		_levelList.members[_currentLevelNumber].draw();
		_player.draw();
		_player.drawHealth();
	}
}