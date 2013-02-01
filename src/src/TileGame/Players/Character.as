package TileGame.Players 
{
	import flash.display.DisplayObject;
	import TileGame.Objects.Bullet;
	import TileGame.Objects.ICorneredObject;
	import TileGame.Tiles.*;
	import TileGame.Geom.*;
	import TileGame.Animations.*;
	
	import flash.geom.Point;
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import mx.core.UIComponent;
	import flash.ui.Keyboard;
	
	public class Character extends Sprite implements ICorneredObject
	{
		protected const MOVE_UP:int = 1;
		protected const MOVE_DOWN:int = 2;
		protected const MOVE_RIGHT:int = 3;
		protected const MOVE_LEFT:int = 4;
		
		public var speed:int = 1;
		public var lifeAmount:int = 10;
		public var canShoot:Boolean = true;
		
		protected var size:int = 15;
		protected var color:uint = 0x00CC00;
		protected var tileArr:Array = new Array();
		protected var tileSideLength:int = 0;
		protected var currentDirection:int = MOVE_UP;
		protected var offset:Number = 0;
		protected var appStage:DisplayObjectContainer = null;
		protected var _corners:Object = null;
		
		/*********************
		 * PUBLIC PROPERTIES *
		 *********************/
		
		public function get corners():Object { return this.getCorners(); }
		public function get offsetX():Number { return this.x - offset; }
		public function get offsetY():Number { return this.y - offset; }
		
		/******************
		 * PUBLIC METHODS *
		 ******************/
		
		public function Character(xpos:int = 0, ypos:int = 0) {			
			//position rectangle
			this.x = xpos;
			this.y = ypos;
			
			//determine offset properties
			this.offset = size / 2;
		} //end default constructor
		
		public function destroy():void {
			//clear all graphics
			this.graphics.clear();
			
			//remove this object from the stage
			var uic:UIComponent = UIComponent(this.parent);
			uic.removeChild(this); //remove Sprite from UIComponent
			uic.parent.removeChild(uic); //remove UIComponent from stage
			uic = null;
		} //end method destroy
		
		public function kill():void {
			var halfGraphicLength:Number = Explosion.EXPLOSION_GRAPHIC_SIDE_LENGTH / 2;
			var eX:Number = this.x - halfGraphicLength;
			var eY:Number = this.y - halfGraphicLength;
			
			this.destroy();
			
			var explosion:Explosion = new Explosion(this.appStage);
			explosion.play(eX, eY);
		} //end method kill
		
		public function setMapData(tileMap:Array, sideLength:int):void {
			if (tileMap == null || tileMap.length == 0 || sideLength <= 0)
				throw new Error("Invalid map data specified.");
				
			this.tileArr = tileMap;
			this.tileSideLength = sideLength;
		} //end method setMapData

		public function move(currKC:uint):void {
			if (this.tileSideLength <= 0 || this.tileArr.length == 0)
				return;
			
			this._corners = getCorners();
			var nextTile:BaseTile = null;
			var tileX:int = 0;
			var tileY:int = 0;
			
			/* check for movement */
			if (currKC == Keyboard.RIGHT) {
				//first find the top right tile
				tileY = Math.floor((this._corners.TopRight.x + this.speed) / this.tileSideLength);
				nextTile = tileArr[this._corners.TopRight.tileX][tileY];
				
				//if the tile that the top right corner runs in to is walkable,
				//then we must determine if the bottom right corner tile is walkable
				if(nextTile.isWalkable()) {
					//now find the bottom right tile
					tileY = Math.floor((this._corners.BottomRight.x + this.speed) / this.tileSideLength);
					nextTile = tileArr[this._corners.BottomRight.tileX][tileY];
					
					if(nextTile.isWalkable()) {
						//allow move right
						this.updateDirection(MOVE_RIGHT);
						this.moveDirection(MOVE_RIGHT);
					} //end if
					else {
						//make the hero flush with the next tile
						this.x = nextTile.x - this.width - 0.1 + this.offset;
					} //end else
				} //end if
				else {
					//make the hero flush with the next tile
					this.x = nextTile.x - this.width - 0.1 + this.offset;
				} //end else
			} //end if
			else if (currKC == Keyboard.LEFT) {
				//first find the top left tile
				tileY = Math.floor((this._corners.TopLeft.x - this.speed) / this.tileSideLength);
				nextTile = tileArr[this._corners.TopLeft.tileX][tileY];
				
				//if the tile that the top left corner runs in to is walkable,
				//then we must determine if the bottom left corner tile is walkable
				if(nextTile.isWalkable()) {
					//now find the bottom left tile
					tileY = Math.floor((this._corners.BottomLeft.x - this.speed) / this.tileSideLength);
					nextTile = tileArr[this._corners.BottomLeft.tileX][tileY];
					
					if(nextTile.isWalkable()) {
						//allow move left
						this.updateDirection(MOVE_LEFT);
						this.moveDirection(MOVE_LEFT);
					} //end if
					else {
						//make the hero flush with the next tile
						this.x = nextTile.x + this.tileSideLength + this.offset;
					} //end else
				} //end if
				else {
					//make the hero flush with the next tile
					this.x = nextTile.x + this.tileSideLength + this.offset;
				} //end else
			} //end else if
			else if (currKC == Keyboard.UP) {
				//first find the top left tile
				tileX = Math.floor((this._corners.TopLeft.y - this.speed) / this.tileSideLength);
				nextTile = tileArr[tileX][this._corners.TopLeft.tileY];
				
				//if the tile that the top left corner runs in to is walkable,
				//then we must determine if the top right corner tile is walkable
				if(nextTile.isWalkable()) {
					//now find the top right tile
					tileX = Math.floor((this._corners.TopRight.y - this.speed) / this.tileSideLength);
					nextTile = tileArr[tileX][this._corners.TopRight.tileY];
					
					if(nextTile.isWalkable()) {
						//allow move up
						this.updateDirection(MOVE_UP);
						this.moveDirection(MOVE_UP);
					} //end if
					else {
						//make the hero flush with the next tile
						this.y = nextTile.y + this.tileSideLength + this.offset;
					} //end else
				} //end if
				else {
					//make the hero flush with the next tile
					this.y = nextTile.y + this.tileSideLength + this.offset;
				} //end else
			} //end else if
			else if (currKC == Keyboard.DOWN) {
				//first find the bottom left tile
				tileX = Math.floor((this._corners.BottomLeft.y + this.speed) / this.tileSideLength);
				nextTile = tileArr[tileX][this._corners.BottomLeft.tileY];
				
				//if the tile that the top left corner runs in to is walkable,
				//then we must determine if the top right corner tile is walkable
				if(nextTile.isWalkable()) {
					//now find the bottom right tile
					tileX = Math.floor((this._corners.BottomRight.y + this.speed) / this.tileSideLength);
					nextTile = tileArr[tileX][this._corners.BottomRight.tileY];
					
					if(nextTile.isWalkable()) {
						//allow move down
						this.updateDirection(MOVE_DOWN);
						this.moveDirection(MOVE_DOWN);
					} //end if
					else {
						//make the hero flush with the next tile
						this.y = nextTile.y - this.height - 0.1 + this.offset;
					} //end else
				} //end if
				else {
					//make the hero flush with the next tile
					this.y = nextTile.y - this.height - 0.1 + this.offset;
				} //end else
			} //end else if
		} //end method move
		
		public function isCollidingWith(other:ICorneredObject):Boolean {
			if (!(other is Character) && !(other is Bullet)) 
				throw new ArgumentError("Invalid argument specified.  Character-based or Bullet object required.");
			
			//get necessary testing points
			var topLeftTile:BaseTile = this.tileArr[this._corners.TopLeft.tileX][this._corners.TopLeft.tileY];
			var topLeftPoint:Point = new Point(topLeftTile.x, topLeftTile.y);
			
			var topRightTile:BaseTile = this.tileArr[this._corners.TopRight.tileX][this._corners.TopRight.tileY];
			var topRightPoint:Point = new Point(topRightTile.points.TopRight.x, topRightTile.points.TopRight.y);
			
			var bottomLeftTile:BaseTile = this.tileArr[this._corners.BottomLeft.tileX][this._corners.BottomLeft.tileY];
			var bottomLeftPoint:Point = new Point(bottomLeftTile.points.BottomLeft.x, bottomLeftTile.points.BottomLeft.y);
			
			/*
			 * check if surrounding tiles contain any part of the other object
			 */
			var otherCorners:Object = other.corners;
			// -- TopLeft --
			if (otherCorners.TopLeft.x >= topLeftPoint.x &&
				otherCorners.TopLeft.x <= topRightPoint.x &&
				otherCorners.TopLeft.y >= topLeftPoint.y && 
				otherCorners.TopLeft.y <= bottomLeftPoint.y)
				return this.hitTestObject(DisplayObject(other));
				
			// -- TopRight --
			if (otherCorners.TopRight.x >= topLeftPoint.x &&
				otherCorners.TopRight.x <= topRightPoint.x &&
				otherCorners.TopRight.y >= topLeftPoint.y && 
				otherCorners.TopRight.y <= bottomLeftPoint.y)
				return this.hitTestObject(DisplayObject(other));
				
			// -- BottomLeft --
			if (otherCorners.BottomLeft.x >= topLeftPoint.x &&
				otherCorners.BottomLeft.x <= topRightPoint.x &&
				otherCorners.BottomLeft.y >= topLeftPoint.y && 
				otherCorners.BottomLeft.y <= bottomLeftPoint.y)
				return this.hitTestObject(DisplayObject(other));
				
			// -- BottomRight --
			if (otherCorners.BottomRight.x >= topLeftPoint.x &&
				otherCorners.BottomRight.x <= topRightPoint.x &&
				otherCorners.BottomRight.y >= topLeftPoint.y && 
				otherCorners.BottomRight.y <= bottomLeftPoint.y)
				return this.hitTestObject(DisplayObject(other));
				
			return false;
		} //end method isCollidingWith
		
		/****************************
		 * PROTECTED MEMBER METHODS *
		 ****************************/
		
		protected function createChar(target:DisplayObjectContainer):void {
			//draw rectangle
            this.graphics.beginFill(color);
            this.graphics.drawRect(-this.offset, -this.offset, size, size);
			this.graphics.endFill();
			
			//add rectangle to stage
			var uic:UIComponent = new UIComponent();
			uic.addChild(this);
			target.addChild(uic);
			this.appStage = target;
			
			this.width = size;
			this.height = size;
			
			this._corners = this.getCorners();
		} //end method createChar
		
		protected function moveDirection(direction:int):void {
			switch(direction) {
				case MOVE_UP:
					this.y -= this.speed;
					break;
				case MOVE_DOWN: 
					this.y += this.speed;
					break;
				case MOVE_RIGHT:
					this.x += this.speed;
					break;
				case MOVE_LEFT:
					this.x -= this.speed;
					break;
			} //end switch
		} //end method moveDirection

		protected function getCorners():Object {
			var offsetX:Number = this.x - this.offset;
			var offsetY:Number = this.y - this.offset;
			
			var right:int = offsetX + this.width;
			var bottom:int = offsetY + this.height;
			
			return { 
				TopLeft: {
					x:offsetX, 
					y:offsetY,
					tileX:Math.floor(offsetY / this.tileSideLength),
					tileY:Math.floor(offsetX / this.tileSideLength)
				}, 
				TopRight: {
					x:right, 
					y:offsetY,
					tileX:Math.floor(offsetY / this.tileSideLength),
					tileY:Math.floor(right / this.tileSideLength)
				}, 
				BottomLeft: {
					x:offsetX, 
					y:bottom,
					tileX:Math.floor(bottom / this.tileSideLength),
					tileY:Math.floor(offsetX / this.tileSideLength)
				}, 
				BottomRight: {
					x:right, 
					y:bottom,
					tileX:Math.floor(bottom / this.tileSideLength),
					tileY:Math.floor(right / this.tileSideLength)
				}
			}
		} //end method getCorners
		
		protected function updateDirection(newDir:int):void {
			if (this.currentDirection == newDir) return;
			
			var dirTotal:int = this.currentDirection + newDir;
			
			//if we're reversing directions, rotate 180 degrees
			if (dirTotal == 3 || dirTotal == 7)
				this.rotation += 180;
			//if we're moving in directions of some combination of right/up or left/down
			else if (dirTotal == 4 || dirTotal == 6)
				this.rotation += this.currentDirection < newDir ? 90 : -90;
			//if we're moving in directions of some combination of right/down or up/left
			else
				this.rotation += this.currentDirection < newDir ? -90 : 90;
			
			this.currentDirection = newDir;
		} //end method updateDirection
	} //end class Character
} //end package