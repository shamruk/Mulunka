package simpleframework.view {
	import flash.display.DisplayObject;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	public class RootView extends BaseView {
		protected var currentScreen : BaseView;
		//		private var screens : Array = [];

		public function RootView() {
			super();
			if (stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				onAdded();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, onAdded);
			}
		}

		private function onAdded(event : Event = null) : void {
			preinitialize();
			createChildren();
		}

		protected function preinitialize() : void {
		}

		override public function addChild(view : DisplayObject) : DisplayObject {
			if (view is ScreenView) {
				view.visible = false;
				//				screens.push(view);
			}
			return super.addChild(view);
		}

		protected function changeScreen(newScreen : ScreenView) : void {
			if (currentScreen == newScreen) {
				return;
			}
			if (currentScreen) {
				currentScreen.visible = false;
			}
			currentScreen = newScreen;
			currentScreen.visible = true;
		}
	}
}