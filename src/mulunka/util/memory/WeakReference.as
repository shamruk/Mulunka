package mulunka.util.memory {
	import flash.utils.Dictionary;

	public class WeakReference {
		private var dictionary : Dictionary;

		public function WeakReference(object : *) {
			dictionary = new Dictionary(true);
			if (object) {
				dictionary[object] = null;
			}
		}

		public function get get() : * {
			for (var n : Object in dictionary) {
				return n;
			}
			return null;
		}
	}
}