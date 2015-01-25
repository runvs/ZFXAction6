class IdentiyTile extends Tile
{
	private var _sprite:flixel.FlxSprite;

	public function new()
	{
		super();
		_sprite = new flixel.FlxSprite();
		_sprite.loadGraphic(AssetPaths.tile_identitytile__png, false, 32, 32);
		_sprite.scale.set(4, 4);	
	}

	public override function draw()
	{
		_sprite.draw();
		//trace("IdentiyTile::draw()");
	}
}