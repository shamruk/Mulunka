package mulunka.display {
	import flash.display.Shape;

	public class Rect extends Shape {

		private var _color : Number;
		private var _width : Number;
		private var _height : Number;

		public function set color(value : uint) : void {
			if (_color == value) {
				return;
			}
			_color = value;
			invalidateView();
		}

		override public function set width(value : Number) : void {
			if (_width == value) {
				return;
			}
			_width = value;
			invalidateView();
		}

		override public function set height(value : Number) : void {
			if (_height == value) {
				return;
			}
			_height = value;
			invalidateView();
		}

		/** probably should have delayed validation */
		private function invalidateView() : void {
			if (isNaN(_color) || isNaN(_width) || isNaN(_height)) {
				return;
			}
			draw();
		}

		private function draw() : void {
			graphics.clear();
			graphics.beginFill(_color);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();
		}
	}
}
