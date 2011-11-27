package simpleframework.view {
	import simpleframework.model.IModel;
	import simpleframework.model.StateModel;

	public class DataView extends BaseView {
		protected var data : IModel;

		public function DataView(data : IModel) {
			super();
			this.data = data;
		}

		override public function createChildren() : void {
			super.createChildren();
			updateModel();
			if (data is StateModel) {
				bindSetter(onStateChange, data, "state");
			}
		}

		protected function onStateChange(state : String) : void {
		}

		protected function updateModel() : void {
		}
	}
}