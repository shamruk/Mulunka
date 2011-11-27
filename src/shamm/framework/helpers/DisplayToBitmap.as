package shamm.framework.helpers {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	import mx.core.IFactory;

	[DefaultProperty("display")]
	public class DisplayToBitmap extends Bitmap {

		public function set displayFactory(value : IFactory) : void {
			display = value.newInstance();
		}

		/** todo: use smaller bitmapdata */
		public function set display(value : DisplayObject) : void {
			var bounds : Rectangle = value.getBounds(value);
			bitmapData = new BitmapData(bounds.x + bounds.width, bounds.y + bounds.height);
			bitmapData.draw(value);
		}
	}
}
