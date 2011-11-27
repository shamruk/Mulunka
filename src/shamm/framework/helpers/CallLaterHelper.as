package shamm.framework.helpers {
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;

	public class CallLaterHelper {

		private static const handlers : Dictionary = new Dictionary();

		public static function call(handler : Function) : void {
			if (handlers[handler]) {
				return;
			}
			handlers[handler] = true;
			setTimeout(doCall, 1, handler);
		}

		/** to enable recursion change two lines */
		private static function doCall(handler : Function) : void {
			handler();
			delete handlers[handler];
		}
	}
}