package shamm.framework.view {
	import flash.display.Sprite;

	public class VideoView extends Sprite {

//		private var _x : Number;
		private var _width : Number;
		private var _height : Number;

		public function set cameraHolder(value : CameraHolder) : void {
			addChild(value.getPrivateVideoLink());
			updateHorizontal();
			updateVertical();
		}

		override public function set width(value : Number) : void {
			_width = value;
			updateHorizontal();
		}

//		override public function set x(value : Number) : void {
//			_x = value;
//			updateHorizontal();
//		}

		private function updateHorizontal() : void {
			super.width = _width;
//			scaleX = (_mirror ? -1 : 1) * Math.abs(scaleX);
//			super.x=_x + (_mirror ? width : 0);
		}

		override public function set height(value : Number) : void {
			_height = value;
			updateVertical();
		}

		private function updateVertical() : void {
			super.height = _height;
		}
	}
}