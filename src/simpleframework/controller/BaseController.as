package simpleframework.controller {
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class BaseController extends EventDispatcher {

		protected var timer : Timer;

		private var _work : Boolean = false;

		public function BaseController(delay : uint) {
			timer = new Timer(delay);
			timer.addEventListener(TimerEvent.TIMER, onTime);
		}

		private function onTime(event : TimerEvent) : void {
			makeStep();
		}

		protected function makeStep() : void {
			// to be overriden
		}

		public function start() : void {
			work = true;
		}

		public function stop() : void {
			work = false;
		}

		public function get work() : Boolean {
			return _work;
		}

		public function set work(value : Boolean) : void {
			if (value == _work) {
				return;
			}
			_work = value;
			if (_work) {
				timer.start();
			} else {
				timer.stop();
			}
		}

		protected static function genTime(from : Number, length : Number = 0) : uint {
			return getTimer() + (from + length * Math.random()) * 1000;
		}

		protected static function randomElement(array : Array) : * {
			var index : uint = Math.random() * array.length;
			return array[index];
		}
	}
}