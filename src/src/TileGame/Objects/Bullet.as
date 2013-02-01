package TileGame.Objects 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Point;
	import mx.core.UIComponent;
	import TileGame.Tiles.BaseTile;
	import TileGame.Tiles.WallTile;
	
	public class Bullet extends Bitmap implements ICorneredObject
	{	
		public var speed:int = 5;
		
		private static const HALF_PI:Number = Math.PI / 2;
		
		private var appStage:DisplayObjectContainer = null;
		private var sideLength:int = 0;
		private var dirAngle:Number = 0.0;
		private var tileSideLength:int = 0;
		private var _damage:int = 1;
		
		private var xStep:Number = 0.0;
		private var yStep:Number = 0.0;
		
		/*********************
		 * PUBLIC PROPERTIES *
		 *********************/
		
		public function get damage():int { return this._damage; }
		public function get corners():Object { return this.getCorners(); } //end property corners
		
		/*************************
		 * PUBLIC MEMBER METHODS *
		 *************************/
		
		public function Bullet(buffer:BitmapData, sideLength:int, target:DisplayObjectContainer) 
		{
			super(buffer);
			
			if (!BulletFactory.tileArray || BulletFactory.tileArray.length == 0)
				throw new Error("Invalid tile array specified in BulletFactory.");
				
			this.appStage = target;
			this.sideLength = sideLength;
			this.tileSideLength = BulletFactory.tileArray[0][0].width;
		} //end default constructor
		
		public function destroy():void {
			if (this.hasEventListener(Event.ENTER_FRAME))
				this.removeEventListener(Event.ENTER_FRAME, move);
			
			var uic:UIComponent = UIComponent(this.parent);
			this.appStage.removeChild(uic);
			uic.removeChild(this);
			uic = null;
		} //end method destroy
		
		public function fire():void {
			dirAngle = Math.PI - (Math.atan2(mouseY, mouseX) - HALF_PI); //we have to correct 90 degrees for the difference in coordinate planes
			xStep = this.speed * Math.sin(dirAngle);
			yStep = this.speed * Math.cos(dirAngle);
			this.addEventListener(Event.ENTER_FRAME, move);
		} //end method fire
		
		/****************************
		 * PROTECTED MEMBER METHODS *
		 ****************************/
		
		protected function getCorners():Object {
			var right:int = this.x + this.sideLength;
			var bottom:int = this.y + this.sideLength;
			
			return {
				TopLeft: {
					x:this.x,
					y:this.y,
					tileX:Math.floor(this.y / this.tileSideLength),
					tileY:Math.floor(this.x / this.tileSideLength)
				}, 
				TopRight: {
					x:right,
					y:this.y,
					tileX:Math.floor(this.y / this.tileSideLength),
					tileY:Math.floor(right / this.tileSideLength)
				}, 
				BottomLeft: {
					x:this.x,
					y:bottom,
					tileX:Math.floor(bottom / this.tileSideLength),
					tileY:Math.floor(this.x / this.tileSideLength)
				}, 
				BottomRight: {
					x:right,
					y:bottom,
					tileX:Math.floor(bottom / this.tileSideLength),
					tileY:Math.floor(right / this.tileSideLength)
				}
			} //end Object definition
		} //end method getCorners
		
		/**************************
		 * PRIVATE MEMBER METHODS *
		 **************************/
		
		private function move(e:Event):void {
			this.x -= xStep;
			this.y -= yStep;
			
			//if we reach the bounds of the stage, destroy
			if (this.x < 0 || this.x > this.appStage.width || this.y < 0 || this.y > this.appStage.height)
				return this.destroy();

			//if we run into a wall, destroy
			var corners:Object = this.getCorners();
			
			var nextTile:BaseTile = null;
			if (dirAngle <= 0 && dirAngle > -HALF_PI) { //moving towards top right
				nextTile = this.getTile(corners.TopRight.x, corners.TopRight.y);
				if (nextTile is WallTile) return this.destroy();
				nextTile = this.getTile(corners.BottomRight.x, corners.BottomRight.y);
				if (nextTile is WallTile) return this.destroy();
				nextTile = this.getTile(corners.TopLeft.x, corners.TopLeft.y);
				if (nextTile is WallTile) return this.destroy();
			} //end if
			else if (dirAngle <= -HALF_PI && dirAngle > Math.PI) { //moving towards top left
				nextTile = this.getTile(corners.TopLeft.x, corners.TopLeft.y);
				if (nextTile is WallTile) return this.destroy();
				nextTile = this.getTile(corners.BottomLeft.x, corners.BottomLeft.y);
				if (nextTile is WallTile) return this.destroy();
				nextTile = this.getTile(corners.TopRight.x, corners.TopRight.y);
				if (nextTile is WallTile) return this.destroy();
			} //end else if
			else if (dirAngle > 0 && dirAngle < HALF_PI) { //moving towards bottom right
				nextTile = this.getTile(corners.BottomRight.x, corners.BottomRight.y);
				if (nextTile is WallTile) return this.destroy();
				nextTile = this.getTile(corners.TopRight.x, corners.TopRight.y);
				if (nextTile is WallTile) return this.destroy();
				nextTile = this.getTile(corners.BottomLeft.x, corners.BottomLeft.y);
				if (nextTile is WallTile) return this.destroy();
			} //end else if
			else { //moving towards bottom left
				nextTile = this.getTile(corners.BottomLeft.x, corners.BottomLeft.y);
				if (nextTile is WallTile) return this.destroy();
				nextTile = this.getTile(corners.TopLeft.x, corners.TopLeft.y);
				if (nextTile is WallTile) return this.destroy();
				nextTile = this.getTile(corners.BottomRight.x, corners.BottomRight.y);
				if (nextTile is WallTile) return this.destroy();
			} //end else
		} //end method move
		
		private function getTile(xpos:Number, ypos:Number):BaseTile {
			var tileX:int = Math.floor(ypos / this.tileSideLength);
			var tileY:int = Math.floor(xpos / this.tileSideLength);
			
			return BulletFactory.tileArray[tileX][tileY];
		} //end method getTile
	} //end class Bullet
} //end package