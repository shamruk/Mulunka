/**
 * Created by ${PRODUCT_NAME}.
 * User: sms
 * Date: 1/24/11
 * Time: 10:10 PM
 * To change this template use File | Settings | File Templates.
 */
package mulunka.keyboard {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;

	[Event(name="react", type="flash.events.Event")]
	public class AbstractKeyReactor extends EventDispatcher {

		public var work : Boolean = true;

		private var _eventKey : String;
		private var _key : uint;

		public function AbstractKeyReactor(eventKey : String) {
			_eventKey = eventKey;
		}

		public function set view(keyboardDispatcher : IEventDispatcher) : void {
			keyboardDispatcher.addEventListener(_eventKey, onKey, false, 0, true);
		}

		private function onKey(event : KeyboardEvent) : void {
			if (work && event.keyCode == _key) {
				dispatchEvent(new Event("react"));
			}
		}

		public function set key(value : uint) : void {
			_key = value;
		}
	}
}
