package simpleframework.view {
	import flash.events.Event;
	import flash.utils.getTimer;

	public class ScreenView extends ControlsView {

		private var fadeTimeout : uint;

		private var _visible : Boolean;

		public function ScreenView() {
			super();
			super.visible = _visible = false;
			alpha = 0;
		}

		override public function set visible(value : Boolean) : void {
			if (_visible == value) {
				return;
			}
			_visible = value;
			super.visible = true;
			if (value) {
				show();
			}
			startEffect();
		}

		protected function show() : void {
		}

		private function startEffect() : void {
			fadeTimeout = getTimer() + 400;
			addEventListener(Event.ENTER_FRAME, changingVisibility);
		}

		private function changingVisibility(event : Event) : void {
			var target : Number = _visible ? 1 : 0;
			if (Math.abs(target - alpha) < .05 || getTimer() > fadeTimeout) {
				alpha = target;
				super.visible = _visible;
				removeEventListener(Event.ENTER_FRAME, changingVisibility);
			} else {
				//				var s : Number = 4 - 3 * fadeTimer.currentCount // 10;
				alpha += (target - alpha) * .25;
			}
		}
	}
}