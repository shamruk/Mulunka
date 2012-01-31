package mulunka.display {
	import mx.core.IDataRenderer;
	import mx.events.FlexEvent;

	public class ViewItemRenderer extends View implements IDataRenderer {

		private var _data : *;

		[Bindable("dataChange")]
		public function get data() : Object {
			return _data;
		}

		public function set data(value : Object) : void {
			if (_data == value) {
				return;
			}
			_data = value;
			dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
		}
	}
}
