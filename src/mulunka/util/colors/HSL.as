package mulunka.util.colors {
	/**
	 * http://en.wikipedia.org/wiki/HSL_color_space.
	 * Assumes r, g, and b are contained in the set [0, 255] and
	 * returns h, s, and l in the set [0, 1].
	 */
	public class HSL {

		public var h : Number;
		public var s : Number;
		public var l : Number;

		public static function fromColor(color : uint) : HSL {
			var r : Number = color >> 16 & 0xFF;
			var g : Number = color >> 8 & 0xFF;
			var b : Number = color & 0xFF;
			return fromRedGreenBlue(r, g, b);
		}

		public static function fromRedGreenBlue(r : Number, g : Number, b : Number) : HSL {
			var hsl : HSL = new HSL;
			r /= 0xFF;
			g /= 0xFF;
			b /= 0xFF;
			var max : Number = Math.max(r, g, b);
			var min : Number = Math.min(r, g, b);
			hsl.l = (max + min) / 2;

			if (max == min) {
				hsl.h = hsl.s = 0; // achromatic
			} else {
				var d : Number = max - min;
				hsl.s = hsl.l > 0.5 ? d / (2 - max - min) : d / (max + min);
				switch (max) {
					case r:
						hsl.h = (g - b) / d + (g < b ? 6 : 0);
						break;
					case g:
						hsl.h = (b - r) / d + 2;
						break;
					case b:
						hsl.h = (r - g) / d + 4;
						break;
				}
				hsl.h /= 6;
			}

			return hsl;
		}

		public function toCode() : uint {
			var r : Number;
			var g : Number;
			var b : Number;

			if (s == 0) {
				r = g = b = l; // achromatic
			} else {
				var q : Number = l < 0.5 ? l * (1 + s) : l + s - l * s;
				var p : Number = 2 * l - q;
				r = hue2rgb(p, q, h + 1 / 3);
				g = hue2rgb(p, q, h);
				b = hue2rgb(p, q, h - 1 / 3);
			}

			return ((r * 0xFF) << 16) + ((g * 0xFF) << 8) + b * 0xFF;
		}

		private static function hue2rgb(p : Number, q : Number, t : Number) : Number {
			if (t < 0) t += 1;
			if (t > 1) t -= 1;
			if (t < 1 / 6) return p + (q - p) * 6 * t;
			if (t < 1 / 2) return q;
			if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
			return p;
		}

		public function distanceX1(hsl : HSL) : Number {
			var d : Number = Math.abs(s - hsl.s);
			return (d > .5 ? 1 - d : d);
		}

		public function distanceH(hsl : HSL) : Number {
			var dh : Number = Math.abs(h - hsl.h);
			return (dh > .5 ? 1 - dh : dh) * 2;
		}

		public function distanceS(hsl : HSL) : Number {
			var ds : Number = Math.abs(s - hsl.s);
			return ds;
		}

		public function distanceS2(hsl : HSL) : Number {
			var ds : Number = Math.abs(s - hsl.s);
			return ds * ds;
		}

		public function distanceL(hsl : HSL) : Number {
			var dl : Number = Math.abs(l - hsl.l);
			return dl;
		}

		public function distanceHL(hsl : HSL) : Number {
			var dh : Number = Math.abs(h - hsl.h);
			var dl : Number = Math.abs(l - hsl.l);
			return (dh > .5 ? 1 - dh : dh) * 2 * .8 + dl * .2;
		}

		public function distanceHifL(hsl : HSL) : Number {
			if (hsl.l < .1 || hsl.l > .7) {
				return 1;
			}
			var dh : Number = Math.abs(h - hsl.h);
			return (dh > .5 ? 1 - dh : dh) * 2;
		}

		public function distanceHSifL(hsl : HSL) : Number {
			if (hsl.l < .1 || hsl.l > .8) {
				return 1;
			}
			var dh : Number = Math.abs(h - hsl.h);
			var ds : Number = Math.abs(s - hsl.s);
			return (dh > .5 ? 1 - dh : dh) * 2 * .7 + ds * .3;
		}

//		public function distanceHSifLDis(hsl : HSL) : Number {
//			if(hsl.l < .1 || hsl.l > .7){
//				return 1;
//			}
//			var dh : Number = Math.abs(h - hsl.h);
//			var ds : Number = Math.abs(s - hsl.s);
//			return (dh > .5 ? 1 - dh : dh) * 2 * .7 + ds*.3;
//		}

		public function distanceColor(color : uint) : Number {

			var r : Number = color >> 16 & 0xFF;
			var g : Number = color >> 8 & 0xFF;
			var b : Number = color & 0xFF;

			var hslH : Number;
			var hslS : Number;
			var hslL : Number;
			r /= 0xFF;
			g /= 0xFF;
			b /= 0xFF;
			var max : Number = Math.max(r, g, b);
			var min : Number = Math.min(r, g, b);
			hslL = (max + min) / 2;
			if (max == min) {
				hslH = hslS = 0; // achromatic
			} else {
				var d : Number = max - min;
				hslS = hslL > 0.5 ? d / (2 - max - min) : d / (max + min);
				switch (max) {
					case r:
						hslH = (g - b) / d + (g < b ? 6 : 0);
						break;
					case g:
						hslH = (b - r) / d + 2;
						break;
					case b:
						hslH = (r - g) / d + 4;
						break;
				}
				hslH /= 6;
			}


			if (hslL < .1 || hslL > .8) {
				return 1;
			}
			var dh : Number = Math.abs(h - hslH);
			var ds : Number = Math.abs(s - hslS);
			return (dh > .5 ? 1 - dh : dh) * 2 * .7 + ds * .3;
		}
	}
}
