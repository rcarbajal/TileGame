package TileGame.Objects 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import mx.core.UIComponent;
	import flash.events.Event;
	
	public class Bullet1 extends Sprite
	{
		[Embed(source = '../../../assets/bullet1.gif')]
		private const BulletImage:Class;
		
		private var appStage:DisplayObjectContainer = null;
		
		public function Bullet1(target:DisplayObjectContainer, xpos:int, ypos:int) 
		{
			this.x = xpos;
			this.y = ypos;
			this.addChild(new BulletImage() as DisplayObject);
			var uic:UIComponent = new UIComponent();
			uic.addChild(this);
			target.addChild(uic);
			this.appStage = target;
		} //end default constructor
		
		public function destroy():void {
			var uic:UIComponent = UIComponent(this.parent);
			this.appStage.removeChild(uic);
			uic.removeChild(this);
			uic = null;
		} //end method destroy
	} //end class Bullet1
} //end package