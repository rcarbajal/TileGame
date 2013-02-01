package TileGame.Players 
{	
	import flash.display.DisplayObjectContainer;
	import TileGame.Objects.*;
	import TileGame.Tiles.*;
	
	public class Enemy extends Character
	{		
		public function Enemy(target:DisplayObjectContainer, xpos:int = 0, ypos:int = 0) 
		{			
			super(xpos, ypos);
			
			//set enemy properties
			this.size = 20;
			this.offset = size / 2;
			this.color = 0xCC0000;
			this.canShoot = false;
			
			//create graphic
			this.createChar(target);
		} //end default constructor
		
		public function shoot():Bullet {
			if (!BulletFactory.tileArray) BulletFactory.tileArray = this.tileArr;
			var halfBulletSideLength:Number = BulletFactory.BULLET_1_SIDE_LENGTH / 2;
			var b:Bullet = BulletFactory.create(BulletType.BULLET_1, this.appStage, this.x - halfBulletSideLength, this.y - halfBulletSideLength);
			b.speed = 5;
			b.fire();
			
			return b;
		} //end method shoot
		
		public override function move(currKC:uint):void {
			if (this.tileSideLength <= 0 || this.tileArr.length == 0)
				return;
			
			this._corners = getCorners();
			var nextTile:BaseTile = null;
			var tileX:int = 0;
			var tileY:int = 0;
			var isStopped:Boolean = false;
			
			//randomly choose a new direction < 2% of the time
			if (Math.random() * 100 > 98.5) chooseNewDirection();
			
			//do moving
			if (this.currentDirection == MOVE_RIGHT) {
				//first find the top right tile
				tileX = Math.floor(this._corners.TopRight.y / this.tileSideLength);
				tileY = Math.floor((this._corners.TopRight.x + this.speed) / this.tileSideLength);
				nextTile = tileArr[tileX][tileY];
				
				//if the tile that the top right corner runs in to is walkable,
				//then we must determine if the bottom right corner tile is walkable
				if(nextTile.isWalkable()) {
					//now find the bottom right tile
					tileX = Math.floor(this._corners.BottomRight.y / this.tileSideLength);
					tileY = Math.floor((this._corners.BottomRight.x + this.speed) / this.tileSideLength);
					nextTile = tileArr[tileX][tileY];
					
					if(nextTile.isWalkable()) {
						//allow move right
						this.moveDirection(MOVE_RIGHT);
					} //end if
					else {
						//make the hero flush with the next tile
						this.x = nextTile.x - this.width - 0.1 + this.offset;
						isStopped = true;
					} //end else
				} //end if
				else {
					//make the hero flush with the next tile
					this.x = nextTile.x - this.width - 0.1 + this.offset;
					isStopped = true;
				} //end else
			} //end if
			else if (this.currentDirection == MOVE_LEFT) {
				//first find the top left tile
				tileX = Math.floor(this._corners.TopLeft.y / this.tileSideLength);
				tileY = Math.floor((this._corners.TopLeft.x - this.speed) / this.tileSideLength);
				nextTile = tileArr[tileX][tileY];
				
				//if the tile that the top left corner runs in to is walkable,
				//then we must determine if the bottom left corner tile is walkable
				if(nextTile.isWalkable()) {
					//now find the bottom left tile
					tileX = Math.floor(this._corners.BottomLeft.y / this.tileSideLength);
					tileY = Math.floor((this._corners.BottomLeft.x - this.speed) / this.tileSideLength);
					nextTile = tileArr[tileX][tileY];
					
					if(nextTile.isWalkable()) {
						//allow move left
						this.moveDirection(MOVE_LEFT);
					} //end if
					else {
						//make the hero flush with the next tile
						this.x = nextTile.x + this.tileSideLength + this.offset;
						isStopped = true;
					} //end else
				} //end if
				else {
					//make the hero flush with the next tile
					this.x = nextTile.x + this.tileSideLength + this.offset;
					isStopped = true;
				} //end else
			} //end else if
			else if (this.currentDirection == MOVE_UP) {
				//first find the top left tile
				tileX = Math.floor((this._corners.TopLeft.y - this.speed) / this.tileSideLength);
				tileY = Math.floor(this._corners.TopLeft.x / this.tileSideLength);
				nextTile = tileArr[tileX][tileY];
				
				//if the tile that the top left corner runs in to is walkable,
				//then we must determine if the top right corner tile is walkable
				if(nextTile.isWalkable()) {
					//now find the top right tile
					tileX = Math.floor((this._corners.TopRight.y - this.speed) / this.tileSideLength);
					tileY = Math.floor(this._corners.TopRight.x / this.tileSideLength);
					nextTile = tileArr[tileX][tileY];
					
					if(nextTile.isWalkable()) {
						//allow move up
						this.moveDirection(MOVE_UP);
					} //end if
					else {
						//make the hero flush with the next tile
						this.y = nextTile.y + this.tileSideLength + this.offset;
						isStopped = true;
					} //end else
				} //end if
				else {
					//make the hero flush with the next tile
					this.y = nextTile.y + this.tileSideLength + this.offset;
					isStopped = true;
				} //end else
			} //end else if
			else if (this.currentDirection == MOVE_DOWN) {
				//first find the top left tile
				tileX = Math.floor((this._corners.BottomLeft.y + this.speed) / this.tileSideLength);
				tileY = Math.floor(this._corners.BottomLeft.x / this.tileSideLength);
				nextTile = tileArr[tileX][tileY];
				
				//if the tile that the top left corner runs in to is walkable,
				//then we must determine if the top right corner tile is walkable
				if(nextTile.isWalkable()) {
					//now find the top right tile
					tileX = Math.floor((this._corners.BottomRight.y + this.speed) / this.tileSideLength);
					tileY = Math.floor(this._corners.BottomRight.x / this.tileSideLength);
					nextTile = tileArr[tileX][tileY];
					
					if(nextTile.isWalkable()) {
						//allow move down
						this.moveDirection(MOVE_DOWN);
					} //end if
					else {
						//make the hero flush with the next tile
						this.y = nextTile.y - this.height - 0.1 + this.offset;
						isStopped = true;
					} //end else
				} //end if
				else {
					//make the hero flush with the next tile
					this.y = nextTile.y - this.height - 0.1 + this.offset;
					isStopped = true;
				} //end else
			} //end else if
			
			//if we're stopped choose a new direction that's not our current direction and not the reverse direction
			if (isStopped) chooseNewDirection();
		} //end method doMovement
		
		protected override function createChar(target:DisplayObjectContainer):void 
		{
			super.createChar(target);
			this.graphics.beginFill(0x000000);
			this.graphics.drawRect(8 - offset, -offset, 4, 6);
			this.graphics.endFill();
		} //end method createChar
		
		private function chooseNewDirection():void {
				var newDir:int = this.currentDirection;
				var isReverse:Boolean = true;
				while (newDir == this.currentDirection || isReverse) {
					newDir = Math.ceil(Math.random() * 4);
					isReverse = newDir + this.currentDirection == 3 || newDir + this.currentDirection == 7;
				} //end while
				this.updateDirection(newDir);
		} //end method chooseNewDirection
	} //end class Enemy
} //end namespace