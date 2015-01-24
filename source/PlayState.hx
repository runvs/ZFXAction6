package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
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
	
	var map : flixel.tile.FlxTilemap;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		//_level = new Level(this, 5, 5);
		//add(MapGenerator.generate(64, 64));
	
		
		map = new flixel.tile.FlxTilemap();

		map.loadMap(MapGenerator.generateMapFromTree(MapGenerator.generateTree(32, 32)).toString(), AssetPaths.SpriteSheetA__png, 16, 16);
		map.setTileProperties(0, FlxObject.ANY);
		map.setTileProperties(1, FlxObject.NONE);
		map.setTileProperties(2, FlxObject.NONE);
		map.setTileProperties(3, FlxObject.NONE);
		map.setTileProperties(4, FlxObject.NONE);
		map.setTileProperties(5, FlxObject.NONE);
		map.scale.set(2, 2);
		
		add(map);	

		
			
		_player = new Player();
		
		for (i in 0 ... map.widthInTiles)
		{
			for (j in 0 ... map.heightInTiles)
			{
				if ( map.getTile(i, j) != 0)
				{
					_player.setPosition(16 * i, 16 * j);
					break;
				}
			}
		}
		
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
		FlxG.collide(_player, map);
	}	

	override public function draw():Void
	{
		//_level.draw();	
		super.draw();
		_player.draw();
		
		_player.drawHealth();
	}
}