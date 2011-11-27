package simpleframework.view {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import mulunka.display.BaseView;

	public class ControlsView extends BaseView {
		public function ControlsView() {
			super();
		}

		protected function addButton(mcSkin : MovieClip) : BaseButtonView {
			var btn : BaseButtonView = new BaseButtonView(mcSkin);
			addChild(btn);
			return btn;
		}

		protected function addButtonHandlingClick(mcSkin : MovieClip, handler : Function) : BaseButtonView {
			var btn : BaseButtonView = addButton(mcSkin);
			btn.addEventListener(MouseEvent.CLICK, handler);
			return btn;
		}

		protected function addButtonDispatchingEvent(mcSkin : MovieClip, customEvent : Event) : BaseButtonView {
			return addButtonHandlingClick(mcSkin, generateEventHandler(customEvent));
		}

		private function generateEventHandler(customEvent : Event) : Function {
			var handler : Function = function(event : Event) : void {
				dispatchEvent(customEvent.clone());
			}
			return handler;
		}
	}
}