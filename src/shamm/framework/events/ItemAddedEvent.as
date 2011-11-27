/**
 * Created by ${PRODUCT_NAME}.
 * User: sms
 * Date: 2/15/11
 * Time: 11:10 PM
 * To change this template use File | Settings | File Templates.
 */
package shamm.framework.events {
	import flash.events.Event;

	public class ItemAddedEvent extends Event {

		public static const ITEM_ADDED : String = "itemAdded";

		private var _item : *;

		public function ItemAddedEvent(item : *) {
			super(ITEM_ADDED);
			_item = item;
		}

		public function get item() : * {
			return _item;
		}
	}
}
