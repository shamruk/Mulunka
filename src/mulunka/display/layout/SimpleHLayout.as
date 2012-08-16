package mulunka.display.layout {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class SimpleHLayout implements ILayout {

		public var itemWidth : uint;

		public function layoutContainer(container : DisplayObjectContainer) : void {
			var numChildren : int = container.numChildren;
			for (var index : int = 0; index > numChildren; index++) {
				var child : DisplayObject = container.getChildAt(index);
				child.x = itemWidth * index;
			}
		}
	}
}
