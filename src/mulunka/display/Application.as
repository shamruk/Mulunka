package mulunka.display {
	import flash.events.Event;

	public class Application extends View {

		private var _width : Number = 0;
		private var _height : Number = 0;

		public function Application() {
			super();
			if (!width) {
				addEventListener(Event.ENTER_FRAME, onWaitInit);
			}
		}

		private function onWaitInit(event : Event) : void {
			if (width) {
				removeEventListener(Event.ENTER_FRAME, onWaitInit);
				dispatchEvent(new Event("stageResized"));
			}
		}

		[Inspectable(enumeration="exactFit,noBorder,noScale,showAll")]
		public function set scaleMode(value : String) : void {
			if (stage) {
				stage.scaleMode = value;
			}
		}

		[Inspectable(enumeration="L,BR,B,TL,TR,T,BLR")]
		public function set align(value : String) : void {
			if (stage) {
				stage.align = value;
			}
		}


		[Bindable("resize")]
		[Bindable("stageResized")]
		override public function get width() : Number {
			return _width || stage.stageWidth;
		}

		[Bindable("resize")]
		[Bindable("stageResized")]
		override public function get height() : Number {
			return _height || stage.stageHeight;
		}

		override public function set width(value : Number) : void {
			_width = value;
		}

		override public function set height(value : Number) : void {
			_height = value;
		}
	}
}