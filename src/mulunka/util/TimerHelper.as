package mulunka.util {
	import flash.utils.Timer;

	[Event(type="flash.events.TimerEvent", name="timer")]
	[Event(type="flash.events.TimerEvent", name="timerComplete")]
	public class TimerHelper extends Timer {

		public function TimerHelper() {
			super(1000);
		}

		public function set work(value : Boolean) : void {
			if (value == super.running) {
				return;
			}
			if (value) {
				start();
			} else {
				stop();
			}
		}
	}
}
