package mulunka.display.layout {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	[Event(type="flash.events.Event", name="widthChanged")]
	public class SimpleHLayout extends EventDispatcher implements ILayout {

		public var itemWidth : uint;

		private var _width : uint;

		public function layoutContainer(container : DisplayObjectContainer) : void {
			var numChildren : int = container.numChildren;
			for (var index : int = 0; index < numChildren; index++) {
				var child : DisplayObject = container.getChildAt(index);
				var itemX : int = itemWidth * index;
				if (itemX != child.x) {
					child.x = itemX;
				}
			}
			var newWidth : uint = numChildren * itemWidth;
			if (newWidth != _width) {
				_width = newWidth;
				dispatchEvent(new Event("widthChanged"))
			}
		}

		public function get width() : uint {
			return _width;
		}
	}
}
