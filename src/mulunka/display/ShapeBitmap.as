package mulunka.display {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;

	public class ShapeBitmap extends Shape {

		public var centring : Boolean = false;

		public function set source(value : Class) : void {
			var sourceBitmap : Bitmap = new value;
			var bitmapData : BitmapData = sourceBitmap.bitmapData;

			var shiftX : uint = centring ? bitmapData.width / 2 : 0;
			var shiftY : uint = centring ? bitmapData.height / 2 : 0;
			var matrix : Matrix;
			if (shiftX || shiftY) {
				matrix = new Matrix();
				matrix.translate(-shiftX, -shiftY);
			}
			graphics.beginBitmapFill(bitmapData, matrix, false, false);
			graphics.drawRect(-shiftX, -shiftY, bitmapData.width, bitmapData.height);
			graphics.endFill();
		}
	}
}
