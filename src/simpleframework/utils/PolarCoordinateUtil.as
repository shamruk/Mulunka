package simpleframework.utils {
	/**
	 * @author sms
	 */
	public class PolarCoordinateUtil {

		public static function mergeAngles(a : uint, b : uint) : int {
			return Math.abs(a - b) > 180 ? (a + b + 360) / 2 : (a + b) / 2;
		}

		public static function mergeAnglesWithCoo(a : uint, b : uint, coo : Number = .1) : int {
			if (a - b > 180) {
				b += 360;
			} else if (b - a > 180) {
				a += 360;
			}
			return a * (1 - coo) + b * coo;
		}

		public static function poToX(r : Number, a : uint) : Number {
			return r * Math.cos(a / 180 * Math.PI);
		}

		public static function poToY(r : Number, a : uint) : Number {
			return r * Math.sin(a / 180 * Math.PI);
		}

		public static function xyToR(x : Number, y : Number) : Number {
			return Math.sqrt(x * x + y * y);
		}

		public static function xyToA(x : Number, y : Number) : Number {
			var a : int = x ? Math.atan2(y, x) / Math.PI * 180 : (y > 0 ? 90 : 270);
			return normalize(a);
			//return xyrToA(x, y, xyToR(x, y));
		}

		public static function xyrToA(x : Number, y : Number, r : Number) : Number {
			return x + y ? Math.acos(x / r) / Math.PI * 180 : 0;
		}

		public static function normalize(value : int) : uint {
			while (value >= 360) {
				value -= 360;
			}
			while (value < 0) {
				value += 360;
			}
			return value;
		}
	}
}
