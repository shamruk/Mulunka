package simpleframework.view {
	import flash.display.MovieClip;

	import simpleframework.model.IModel;

	public class InteractiveView extends DataView {

		private var _depth : uint;

		public function InteractiveView(data : IModel, mcSkin : MovieClip = null) {
			super(data);
			skin = mcSkin;
			if (skin && skin.parent) {
				_depth = skin.parent.getChildIndex(skin);
			}
		}

		protected function get mcSkin() : MovieClip {
			return skin as MovieClip;
		}

		public function get depth() : uint {
			return _depth;
		}
	}
}