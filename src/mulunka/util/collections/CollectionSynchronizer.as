package mulunka.util.collections {
	import mulunka.logging.warn;

	import mx.collections.IList;

	public class CollectionSynchronizer {
		private static function findIndexById(id : String, collection : *, fromIndex : int = 0) : int {
			var list : IList = collection as IList;
			for (var idx : int = fromIndex, size : int = collection.length; idx < size; idx++) {
				if (IIdentifiable(list ? list.getItemAt(idx) : collection[idx]).id == id) {
					return idx;
				}
			}

			return -1;
		}

		public static function synchronizeCollections(sourceCollection : *, targetCollection : IList, converter : Function = null) : void {
			var sourceIdentifiable : IIdentifiable;
			var modelIdentifiable : IIdentifiable;
			var sourceList : IList = sourceCollection as IList;

			var idx : int;
			for (idx = targetCollection.length - 1; idx >= 0; idx--) {
				modelIdentifiable = targetCollection.getItemAt(idx) as IIdentifiable;
				if (findIndexById(modelIdentifiable.id, sourceCollection) < 0) {
					targetCollection.removeItemAt(idx);
				}
			}

			for (idx = 0; idx < sourceCollection.length; idx++) {
				sourceIdentifiable = sourceList ? IIdentifiable(sourceList.getItemAt(idx)) : sourceCollection[idx];
				var pos : int = findIndexById(sourceIdentifiable.id, targetCollection, idx);
				if (pos < 0) {
					targetCollection.addItemAt(converter ? converter(sourceIdentifiable) : sourceIdentifiable, idx);
				} else if (pos != idx) {
					modelIdentifiable = IIdentifiable(targetCollection.removeItemAt(pos));
					targetCollection.addItemAt(modelIdentifiable, idx);
				}
			}

			if (sourceCollection.length != targetCollection.length) {
				mulunka.logging.warn("Strange error in synchronization");
			}
		}
	}
}