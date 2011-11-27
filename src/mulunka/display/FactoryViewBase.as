package mulunka.display {
	import flash.display.DisplayObject;

	import mulunka.display.View;

	import mx.core.IFactory;

	import mulunka.events.ItemAddedEvent;

	[Event(name="itemAdded",type="mulunka.events.ItemAddedEvent")]
	public class FactoryViewBase extends View {

		private var _itemRendererFunction : Function;
		private var _skinRendererFunction : Function;
		private var _itemRenderer : IFactory;
		private var _skinRenderer : IFactory;

		public function FactoryViewBase() {
		}

		public function set itemRendererFunction(value : Function) : void {
			_itemRendererFunction = value;
		}

		public function set skinRendererFunction(value : Function) : void {
			_skinRendererFunction = value;
		}

		public function set itemRenderer(value : IFactory) : void {
			_itemRenderer = value;
		}

		public function set skinRenderer(value : IFactory) : void {
			_skinRenderer = value;
		}

		public function addItem(key : *) : DisplayObject {
			var factory : IFactory = _itemRendererFunction ? IFactory(_itemRendererFunction(key)) : _itemRenderer;
			var view : * = factory.newInstance();
			var skinFactory : IFactory = _skinRendererFunction ? IFactory(_skinRendererFunction(key)) : _skinRenderer;
			if (skinFactory && view is View) {
				View(view).skinFactory = skinFactory;
			}
			addChild(view);
			dispatchEvent(new ItemAddedEvent(view));
			return view;
		}
	}
}
