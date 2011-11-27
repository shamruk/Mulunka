package simpleframework.model {
	public class StateModel implements IModel {

		private var _state : String;

		[Bindable]
		public function get state() : String {
			return _state;
		}

		public function set state(value : String) : void {
			_state = value;
		}
	}
}