package ;

/**
 * ...
 * @author 
 */
class Hektar extends BluePrint
{

	public function new() 
	{
		super();
		requiredItems.set("Lack", 1);
		requiredItems.set("Item", 10);
		
		_infoString = "Apply Damage";
	}
	
}