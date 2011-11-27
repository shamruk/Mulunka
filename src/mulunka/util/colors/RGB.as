package mulunka.util.colors {
	import flash.display.BitmapData;

	public class RGB {

		public var r : uint;
		public var g : uint;
		public var b : uint;

		public function RGB(r : uint = 0, g : uint = 0, b : uint = 0) {
			this.r = r;
			this.g = g;
			this.b = b;
		}

		public function merge(rgb : RGB) : RGB {
			r = (r + rgb.r) * .5;
			g = (g + rgb.g) * .5;
			b = (b + rgb.b) * .5;
			return this;
		}

		public function clone() : RGB {
			return new RGB(r, g, b);
		}

		public function toCode() : uint {
			return (r << 16) + (g << 8) + b;
		}

		public function difference(rgb : RGB) : Number {
			return (Math.abs(r - rgb.r) + Math.abs(g - rgb.g) + Math.abs(b - rgb.b)) / 0xFF / 3;
		}


		public function toString() : String {
			return "RGB{" + r + "-" + g + "-" + b + "}";
		}

		public static function fromCode(code : uint) : RGB {
			return new RGB(code >> 16 & 0xFF, code >> 8 & 0xFF, code & 0xFF);
		}

		public function simpleDistance(rgb : RGB) : Number {
			return (Math.abs(rgb.r - r) + Math.abs(rgb.g - g) + Math.abs(rgb.b - b)) / 3 / 0xff;
		}

		public function distance(rgb : RGB) : Number {
			return Math.sqrt(squareDistance(rgb));
		}

		public function squareDistance(rgb : RGB) : Number {
			var dr : int = (rgb.r - r);
			var dg : int = (rgb.g - g);
			var db : int = (rgb.b - b);
			return (dr * dr + dg * dg + db * db) / 3 / 0xff / 0xff;
		}

		private static const DIVIDER : Number = 1 / 3 / 0xff / 0xff;

		public function squareDistanceFromColor(code : uint) : Number {
			var dr : int = (code >> 16 & 0xFF) - r;
			var dg : int = (code >> 8 & 0xFF) - g;
			var db : int = (code & 0xFF) - b;
			return (dr * dr + dg * dg + db * db) * DIVIDER;
		}

		public function mDistance(rgb : RGB) : Number {
			var dr : int = (rgb.r - r);
			var dg : int = (rgb.g - g);
			var db : int = (rgb.b - b);
			return (Math.sqrt(dr * dr) + Math.sqrt(dg * dg) + Math.sqrt(db * db)) / 3 / 0xff;
		}

		public function mmDistance(rgb : RGB) : Number {
			var dr : uint = Math.abs(rgb.r - r);
			var dg : uint = Math.abs(rgb.g - g);
			var db : uint = Math.abs(rgb.b - b);
			return (dr * dr * dr + dg * dg * dg + db * db * db) / 3 / 0xff / 0xff / 0xff;
		}

		public static function getRGBPixelFromBitmapData(bitmapData : BitmapData, x : uint, y : uint) : RGB {
			return fromCode(bitmapData.getPixel32(x, y));
		}
	}
}