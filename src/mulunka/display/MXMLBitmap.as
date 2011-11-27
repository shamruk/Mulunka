package mulunka.display {
	import flash.display.Bitmap;
	import flash.events.Event;

	public class MXMLBitmap extends Bitmap {
		public function set source(value : Class) : void {
			var sourceBitmap : Bitmap = new value;
			bitmapData = sourceBitmap.bitmapData;
			dispatchEvent(new Event("widthChanged"));
			dispatchEvent(new Event("heightChanged"));
		}

		[Bindable("widthChanged")]
		override public function get width() : Number {
			return super.width;
		}

		override public function set width(value : Number) : void {
			if (value == super.width) {
				return;
			}
			super.width = value;
			dispatchEvent(new Event("widthChanged"));
		}

		[Bindable("heightChanged")]
		override public function get height() : Number {
			return super.height;
		}

		override public function set height(value : Number) : void {
			if (value == super.height) {
				return;
			}
			super.height = value;
			dispatchEvent(new Event("heightChanged"));
		}
	}
}
