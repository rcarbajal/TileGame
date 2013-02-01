package TileGame.Players 
{
	import TileGame.Objects.*;
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	public class Hero extends Character
	{		
		public function Hero(target:DisplayObjectContainer, xpos:int = 0, ypos:int = 0) 
		{
			super(xpos, ypos);
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
		
		protected override function createChar(target:DisplayObjectContainer):void 
		{
			super.createChar(target);
			this.graphics.beginFill(0x000000);
			this.graphics.drawRect(6 - offset, -offset, 4, 6);
			this.graphics.endFill();
		} //end method createChar
	} //end class Hero
} //end package