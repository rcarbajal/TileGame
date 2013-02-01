package TileGame.Tiles
{
	import flash.display.*;
	import flash.geom.Point;
	import mx.core.UIComponent;
	
	public class BaseTile extends Sprite
	{
		protected var walkable:Boolean = true;
		protected var bgColor:uint;
		protected var tWidth:int;
		protected var tHeight:int;
		protected var _points:Object = new Object();
		
		public function isWalkable():Boolean { return this.walkable; }
		
		public function get points():Object { return this._points; }
		public function get color():uint { return this.bgColor; }
		
		public function BaseTile(tileWidth:int = 20, tileHeight:int = 20, xpos:int = 0, ypos:int = 0) 
		{
			//set parameters
			this.bgColor = 0xFFFFFF;
			this.tWidth = tileWidth;
			this.tHeight = tileHeight;
			
			//position rectangle
			this.x = xpos;
			this.y = ypos;
		} //end default constructor
		
		public function draw(target:DisplayObjectContainer):void {
			//draw rectangle
            this.graphics.beginFill(this.bgColor);
            this.graphics.drawRect(0, 0, this.tWidth, this.tHeight);
			this.graphics.endFill();
			
			//add rectangle to stage
			var uic:UIComponent = new UIComponent();
			uic.addChild(this);
			target.addChild(uic);
			
			this.width = this.tWidth;
			this.height = this.tHeight;
			
			this._points = {
				TopLeft: { x:this.x, y:this.y },
				TopRight: { x:this.x + this.tWidth, y:this.y },
				BottomLeft: { x:this.x, y:this.y + this.tHeight },
				BottomRight: { x:this.x + this.tWidth, y:this.y + this.tHeight }
			}
		} //end method draw
		
		public function recolor(newColor:uint):void {
			this.graphics.clear();
			
			//draw rectangle
            this.graphics.beginFill(newColor);
            this.graphics.drawRect(0, 0, this.tWidth, this.tHeight);
			this.graphics.endFill();
		} //end method recolor
		
		public function containsPoint(xCoord:int, yCoord:int):Boolean {
			return xCoord >= this._points.TopLeft.x &&
				xCoord <= this._points.TopRight.x &&
				yCoord >= this._points.TopLeft.y &&
				yCoord <= this._points.BottomLeft.y;
		} //end method containsPoint
	} //end class BaseTile
} //end package