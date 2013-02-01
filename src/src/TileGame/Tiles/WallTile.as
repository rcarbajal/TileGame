package TileGame.Tiles 
{
	public class WallTile extends BaseTile
	{
		public function WallTile(tileWidth:int = 20, tileHeight:int = 20, xpos:int = 0, ypos:int = 0) 
		{
			//set parameters
			this.walkable = false;
			this.bgColor = 0x000000;
			this.tWidth = tileWidth;
			this.tHeight = tileHeight;
			
			//position rectangle
			this.x = xpos;
			this.y = ypos;
		} //end default constructor
	} //end class WallTile
} //end package