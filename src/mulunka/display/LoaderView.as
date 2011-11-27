package mulunka.display {
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	import mulunka.display.View;

	[Event(type="flash.events.Event", name="complete")]
	[Event(type="flash.events.IOErrorEvent", name="ioError")]
	public class LoaderView extends View {

		private var loader : Loader;

		public function set url(value : String) : void {
			if (loader) {
				loader.close();
				loader.unloadAndStop();
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				loader = null;
			} else if (skin is Loader) {
				Loader(skin).unloadAndStop();
			}
			if (value) {
				loader = new Loader();
				loader.load(new URLRequest(value));
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			}
		}

		private function onError(event : IOErrorEvent) : void {
			dispatchEvent(event);
			loader = null;
		}

		private function onComplete(event : Event) : void {
			skin = loader;

			// todo: createChildren
			addChild(skin);

			loader = null;

			dispatchEvent(event);
		}
	}
}
