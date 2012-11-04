package mulunka.util {
	import flash.utils.Dictionary;

	import mulunka.logging.debug;

	public class UniqueObjectName {

		private static const NAME_FILTER : RegExp = /\[object (\w+)\]/;

		private static const objectMap : Dictionary = new Dictionary(true);
		private static const names : Object = {};

		public static function getUID(object : *) : String {
			return objectMap[object] || getNewUID(object);
		}

		private static function getNewUID(object : *) : String {
			var id : String = getBestName(object);
			if (names[id]) {
				var uid : String = id + names[id];
				while (names[uid]) {
					mulunka.logging.debug("UniqueObjectName", "strange");
					names[id]++;
					uid = id + names[id];
				}
				id = uid;
			}
			names[id] = 1;
			objectMap[object] = id;
			return id;
		}

		private static function getBestName(object : *) : String {
			if ("id" in object) {
				return object["id"];
			}
			var name : String = String(object);
			if (NAME_FILTER.test(name)) {
				return NAME_FILTER.exec(name)[1];
			}
			return name;
		}
	}
}
