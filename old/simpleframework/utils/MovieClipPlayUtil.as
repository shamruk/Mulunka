package simpleframework.utils {
	import flash.display.MovieClip;
	import flash.events.Event;

	public class MovieClipPlayUtil {
		public static function playLabel(mc : MovieClip, label : String) : void {
			mc.neededLabel = label;
			mc.gotoAndPlay(label);
			mc.addEventListener(Event.ENTER_FRAME, onFrame);
		}

		private static function onFrame(event : Event) : void {
			var mc : MovieClip = event.target as MovieClip;
			if (mc.currentLabel != mc.neededLabel) {
				mc.stop();
				mc.removeEventListener(Event.ENTER_FRAME, onFrame);
			}
		}
	}
}