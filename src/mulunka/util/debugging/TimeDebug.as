package mulunka.util.debugging {
	import flash.utils.getTimer;

	import mulunka.logging.debug;

	public class TimeDebug {

		private static var time : uint;
		private static var subTime : uint;
		private static var times : Object = {};
		private static var timeSums : Object = {};
		private static var timeCounts : Object = {};
		private static var timeDepths : Object = {};

		public static function reset(object : *) : void {

			for (var id : String in timeSums) {
				debug("time sum", timeSums[id], timeCounts[id], id);
				timeSums[id] = 0;
				timeCounts[id] = 0;
			}

			var d : uint = getTimer() - time;
			time += d;
			var sd : uint = getTimer() - subTime;
			subTime += sd;
			debug("time reset", sd, d, object, "---------------------------");
		}

		public static function log(object : *, info : *) : void {
			var sd : uint = getTimer() - subTime;
			subTime += sd;
			debug("time log", sd, getTimer() - time, info, object);
		}

		public static function start(object : *, id : String) : void {
			if (!timeDepths[id]) {
				times[id] = getTimer();
			}

			timeDepths[id] = (timeDepths[id] || 0) + 1;
		}

		public static function finish(object : *, id : String, skipLog : Boolean = true) : void {
			if (timeDepths[id] == null) {
				return;
			}

			if (timeDepths[id] == 1) {
				var delta : uint = getTimer() - times[id];
				timeSums[id] = (timeSums[id] || 0) + delta;
				timeCounts[id] = (timeCounts[id] || 0) + 1;

				if (!skipLog) {
					debug("time finish", delta, id, object);
				}

				timeDepths[id] = null;
			} else {
				timeDepths[id] = timeDepths[id] > 1 ? timeDepths[id] - 1 : 0;
			}
		}
	}
}