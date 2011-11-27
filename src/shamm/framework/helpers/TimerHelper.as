package shamm.framework.helpers {
	import flash.utils.Timer;

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
