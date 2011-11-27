package simpleframework.utils {
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;

	public class KeyboardUtil {
		public static var instance : KeyboardUtil;

		private var keys : Object = {};

		public function KeyboardUtil(root : DisplayObject) {
			root.addEventListener(KeyboardEvent.KEY_DOWN, onDown);
			root.addEventListener(KeyboardEvent.KEY_UP, onUp);
		}

		public static function initialize(root : DisplayObject) : void {
			instance = new KeyboardUtil(root);
		}

		private function onDown(event : KeyboardEvent) : void {
			keys[event.keyCode] = true;
		}

		private function onUp(event : KeyboardEvent) : void {
			keys[event.keyCode] = false;
		}

		public function isPressed(keyCode : uint) : Boolean {
			return keys[keyCode];
		}
	}
}
