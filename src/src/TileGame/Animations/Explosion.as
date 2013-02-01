package TileGame.Animations 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import mx.core.BitmapAsset;
	import mx.core.SoundAsset;
	import mx.core.UIComponent;
	
	public class Explosion
	{
		public static const EXPLOSION_GRAPHIC_SIDE_LENGTH:int = 32;
		
		[Embed(source = '../../../assets/explosion.gif')]
		private static const ExplosionGraphic:Class;
		private const EXPLOSION_GRAPHIC:BitmapAsset = new ExplosionGraphic() as BitmapAsset;

		[Embed(source='../../../assets/explode.mp3')]
		private static const ExplosionSound:Class;
		private const EXPLOSION_SOUND:SoundAsset = new ExplosionSound() as SoundAsset;
	
		private const NUMBER_OF_TILES:int = 6;
		private const ANIMATION_DELAY:int = 5;
		
		private var x:int = 0;
		private var y:int = 0;
		private var animIdx:int = 0;
		private var animCount:int = 0;
		private var repeatMax:int = 0;
		private var repeatCount:int = 0;
		private var bdCanvas:BitmapData = null;
		private var bmCanvas:Bitmap = null;
		private var bmRect:Rectangle = null;
		private var appStage:DisplayObjectContainer = null;
		private var channel:SoundChannel = null;
		
		public function Explosion(target:DisplayObjectContainer)
		{
			this.bdCanvas = new BitmapData(32, 32, true, 0x000000);
			this.bmCanvas = new Bitmap(this.bdCanvas);
			this.bmRect = new Rectangle(0, 0, EXPLOSION_GRAPHIC_SIDE_LENGTH, EXPLOSION_GRAPHIC_SIDE_LENGTH);
			this.appStage = target;
		} //end default constructor
		
		public function play(xpos:int, ypos:int, repeat:int = 1):void {
			this.x = xpos;
			this.y = ypos;
			this.repeatMax = repeat;
			this.repeatCount = 0;
			
			var uic:UIComponent = new UIComponent();
			uic.x = this.x;
			uic.y = this.y;
			uic.addChild(this.bmCanvas);
			this.appStage.addChild(uic);
			
			this.channel = EXPLOSION_SOUND.play();
			this.channel.soundTransform = new SoundTransform(0.25);
			this.appStage.addEventListener(Event.ENTER_FRAME, draw);
		} //end function play
		
		protected function draw(e:Event):void {
			if (this.repeatCount < this.repeatMax) {
				if (this.animCount == ANIMATION_DELAY) {
					++this.animIdx;
					this.animCount = 0;
					
					if (this.animIdx == NUMBER_OF_TILES)  {
						this.animIdx = 0;
						++this.repeatCount;
					} //end if
				} //end if
				else ++this.animCount;
				
				this.bmRect.x = int((this.animIdx % NUMBER_OF_TILES)) * EXPLOSION_GRAPHIC_SIDE_LENGTH;
				this.bmRect.y = int((this.animIdx / NUMBER_OF_TILES)) * EXPLOSION_GRAPHIC_SIDE_LENGTH;
				this.bdCanvas.copyPixels(EXPLOSION_GRAPHIC.bitmapData, this.bmRect, new Point(0, 0));
			} //end if
		
			if (this.repeatCount >= this.repeatMax) {
				this.appStage.removeEventListener(Event.ENTER_FRAME, draw);
				this.destroy();
			} //end if
		} //end method draw
	
		protected function destroy():void {
			var uic:UIComponent = UIComponent(this.bmCanvas.parent);
			this.appStage.removeChild(uic);
			uic.removeChild(this.bmCanvas);
			uic = null;
			
			this.bdCanvas = null;
			this.bmCanvas = null;
			this.bmRect = null;
			this.channel = null;
		} //end method destroy
	} //end class Explosion
} //end package