package mulunka.display {
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	import mulunka.display.layout.ILayout;
	import mulunka.logging.debug;

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

		private var _layout : ILayout;

		public function set dataProvider(value : IList) : void {
			if (_dataProvider == value) {
				return;
			}
			removeOld();
			if (_dataProvider) {
				_dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onChange);
			}
			_dataProvider = value;
			if (_dataProvider) {
				addAllFromNew();
				_dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, onChange);
			}
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
				{
					if (event.items.length == 1) {
						moveItem(event.items[0], event.location, event.oldLocation);
					} else {
						debug(this, "unsupported item quantity")
					}
					break;
				}
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

		private function moveItem(item : *, to : int, from : int) : void {
			var view : DisplayObject = renderers[item];
			if (view) {
				var actualFrom : int = getChildIndex(view);
				if (actualFrom >= 0 && actualFrom != to) {
					setChildIndex(view, to);
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
			layoutAllItems();
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
			layoutAllItems();
		}

		public function set layout(value : ILayout) : void {
			_layout = value;
			layoutAllItems();
		}

		private function layoutAllItems() : void {
			if (_layout) {
				_layout.layoutContainer(this);
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
