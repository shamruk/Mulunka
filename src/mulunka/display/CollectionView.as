package mulunka.display {
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	import mulunka.display.View;

	import mx.collections.IList;
	import mx.core.IDataRenderer;
	import mx.core.IFactory;
	import mx.events.CollectionEvent;

	[Bindable]
	public class CollectionView extends View {

		public var setDataOnlyAfterAdding : Boolean = false;

		public var itemRenderer : IFactory;

		public var itemRendererFunction : Function;

		private const dataProviderViews : Dictionary = new Dictionary(true);

		private var _dataProvider : IList;

		public function set dataProvider(value : IList) : void {
			if (_dataProvider == value) {
				return;
			}
			removeOld();
			if (_dataProvider) {
				_dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, onChange);
			}
			_dataProvider = value;
			if (!_dataProvider) {
				return;
			}
			addAllFromNew();
			value.addEventListener(CollectionEvent.COLLECTION_CHANGE, onChange);
		}

		private function onChange(event : CollectionEvent) : void {
			switch (event.kind) {
//				case CollectionEventKind.ADD:
//				{
//					var t= event.items;
//					break;
//				}
				default:
				{
					debug(this, "not implemented: " + event.kind);
				}
			}
		}

		private function addAllFromNew() : void {
			const dataProviderLength : int = _dataProvider.length;
			for (var index : uint = 0; index < dataProviderLength; index++) {
				var itemModel : * = _dataProvider.getItemAt(index);
				//itemAdded(itemModel, index);
				var item : IDataRenderer = createItem(itemModel);
				addChild(item as DisplayObject);
				dataProviderViews[item] = true;
				if (setDataOnlyAfterAdding) {
					item.data = itemModel;
				}
				//debug(this, "addWW", item["baseModel"].id, item["baseModel"].spreadID);
			}
		}

		private function removeOld() : void {
			for (var oldItem in dataProviderViews) {
				//debug(this, "removeWW", oldItem.baseModel.id, oldItem.baseModel.spreadID);
				removeChild(oldItem as DisplayObject);
				delete dataProviderViews[oldItem];
			}
		}

		private function createItem(model : *) : IDataRenderer {
			var itemFactory : IFactory = itemRenderer || itemRendererFunction(model);
			var item : IDataRenderer = itemFactory.newInstance();
			if (!setDataOnlyAfterAdding) {
				item.data = model;
			}
			return item;
		}
	}
}
