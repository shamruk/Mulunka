package mulunka.display {
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	import mx.collections.IList;
	import mx.core.IDataRenderer;
	import mx.core.IFactory;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;

	[Bindable]
	/** reuse views */
	public class CollectionView extends View {

		public var setDataOnlyAfterAdding : Boolean = false;

		public var itemRenderer : IFactory;

		public var itemRendererFunction : Function;

		private const renderers : Dictionary = new Dictionary(true);
		private const removedRenderersCaches : Dictionary = new Dictionary();

		private var _dataProvider : IList;

		public var cleanData : Boolean = false;
		public var cacheRemovedRenderers : Boolean = false;

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
				case CollectionEventKind.ADD:
				{
					createItems(event.items);
					break;
				}
				case CollectionEventKind.REMOVE:
				{
					removeItems(event.items);
					break;
				}
				case CollectionEventKind.UPDATE:
				{
					break;
				}
				case CollectionEventKind.MOVE:
				case CollectionEventKind.REFRESH:
				{
					debug(this, "not implemented: " + event.kind);
					break;
				}
				case CollectionEventKind.REPLACE:
				case CollectionEventKind.RESET:
				{
					debug(this, "full reset: " + event.kind);
					fullRest();
					break;
				}
				default:
				{
					debug(this, "undefined collection event: " + event.kind);
				}
			}
		}

		private function removeItems(items : Array) : void {
			for (var index : int = numChildren - 1; index >= 0; index--) {
				var child : DisplayObject = getChildAt(index);
				if (child is IDataRenderer) {
					var data : * = IDataRenderer(child).data;
					if (data && items.indexOf(data) >= 0) {
						removeRenderer(child);
					}
				}
			}
		}

		private function fullRest() : void {
			removeOld();
			addAllFromNew();
		}

		private function addAllFromNew() : void {
			createItems(_dataProvider);
		}

		private function createItems(items : *) : void {
			for each(var itemModel : * in items) {
				fullCreateItem(itemModel);
			}
		}

		private function removeOld() : void {
			for (var oldItem in renderers) {
				removeRenderer(oldItem as DisplayObject);
			}
		}

		private function removeRenderer(child : DisplayObject) : void {
			removeChild(child);
			delete renderers[child];
			if (cacheRemovedRenderers) {
				var data : * = IDataRenderer(child).data;
				var itemFactory : IFactory = getFactory(data);
				if (!removedRenderersCaches[itemFactory]) {
					removedRenderersCaches[itemFactory] = new Dictionary(true);
				}
				removedRenderersCaches[itemFactory][child] = true;
			}
			if (cleanData) {
				IDataRenderer(child).data = null;
			}
		}

		private function fullCreateItem(itemModel : *) : IDataRenderer {
			var item : IDataRenderer = createItem(itemModel);
			addChild(item as DisplayObject);
			renderers[item] = true;
			if (setDataOnlyAfterAdding) {
				item.data = itemModel;
			}
			return item;
		}

		private function createItem(model : *) : IDataRenderer {
			var itemFactory : IFactory = getFactory(model);
			var item : IDataRenderer = rendererFromCache(itemFactory) || itemFactory.newInstance();
			if (!setDataOnlyAfterAdding) {
				item.data = model;
			}
			return item;
		}

		private function getFactory(model : *) : IFactory {
			return itemRenderer || itemRendererFunction(model);
		}

		private function rendererFromCache(itemFactory : IFactory) : * {
			if (!cacheRemovedRenderers) {
				return null;
			}
			var removedRenderersCache : Dictionary = removedRenderersCaches[itemFactory];
			for (var renderer in removedRenderersCache) {
				return renderer;
			}
		}
	}
}
