package TileGame.Objects 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import mx.core.UIComponent;
	
	public class BulletFactory
	{
		public static const BULLET_1_SIDE_LENGTH:int = 5;
		public static const BULLET_2_SIDE_LENGTH:int = 9;
		public static const BULLET_3_SIDE_LENGTH:int = 13;
		
		public static var tileArray:Array = null;
		
		private static var buffer1:BitmapData;
		private static var buffer2:BitmapData;
		private static var buffer3:BitmapData;
		
		/*
		 * Bullet image assets
		 */
		[Embed(source = '../../../assets/bullet1.gif')]
		private static var Bullet1Image:Class;
		[Embed(source = '../../../assets/bullet2.gif')]
		private static var Bullet2Image:Class;
		[Embed(source = '../../../assets/bullet3.gif')]
		private static var Bullet3Image:Class;
		
		/*************************
		 * PUBLIC STATIC METHODS *
		 *************************/
		
		public static function create(bulletType:int, target:DisplayObjectContainer, xpos:int, ypos:int):Bullet {
			var bullet:Bullet = null;
			
			switch(bulletType) {
				case BulletType.BULLET_1:
					//make sure our buffer1 BitmapData object is instantiated and drawn
					if (!buffer1) {
						buffer1 = new BitmapData(BULLET_1_SIDE_LENGTH, BULLET_1_SIDE_LENGTH, true, 0x000000);
						buffer1.draw(new Bullet1Image() as DisplayObject);
					} //end if
					
					//return reference to newly created Bullet
					bullet = BulletFactory.createBullet(buffer1, BULLET_1_SIDE_LENGTH, target);
					bullet.x = xpos;
					bullet.y = ypos;
					return bullet;
				case BulletType.BULLET_2:
					if (!buffer2) {
						buffer2 = new BitmapData(BULLET_2_SIDE_LENGTH, BULLET_2_SIDE_LENGTH, true, 0x000000);
						buffer2.draw(new Bullet2Image() as DisplayObject);
					} //end if
					
					//return reference to newly created Bullet
					bullet = BulletFactory.createBullet(buffer2, BULLET_2_SIDE_LENGTH, target);
					bullet.x = xpos;
					bullet.y = ypos;
					return bullet;
				case BulletType.BULLET_3:
					if (!buffer3) {
						buffer3 = new BitmapData(BULLET_3_SIDE_LENGTH, BULLET_3_SIDE_LENGTH, true, 0x000000);
						buffer3.draw(new Bullet3Image() as DisplayObject);
					} //end if
					
					//return reference to newly created Bullet
					bullet = BulletFactory.createBullet(buffer3, BULLET_3_SIDE_LENGTH, target);
					bullet.x = xpos;
					bullet.y = ypos;
					return bullet;
			} //end switch
			
			return bullet;
		} //end static method create
		
		/**************************
		 * PRIVATE STATIC METHODS *
		 **************************/
		
		private static function createBullet(buffer:BitmapData, sideLength:int, target:DisplayObjectContainer):Bullet {
			//create new bullet
			var bullet:Bullet = new Bullet(buffer, sideLength, target);
			
			//add bullet to stage
			var uic:UIComponent = new UIComponent();
			uic.addChild(bullet);
			target.addChild(uic);
			
			return bullet;
		} //end static method createBullet
	} //end class BulletFactory
} //end package