/**
 * Created by ${PRODUCT_NAME}.
 * User: sms
 * Date: 1/24/11
 * Time: 10:10 PM
 * To change this template use File | Settings | File Templates.
 */
package mulunka.keyboard {
	import flash.events.KeyboardEvent;

	public class KeyDownReactor extends AbstractKeyReactor {
		public function KeyDownReactor() {
			super(KeyboardEvent.KEY_DOWN);
		}
	}
}
