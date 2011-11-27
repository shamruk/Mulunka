package mulunka.util {
	import flash.external.ExternalInterface;
	import flash.system.System;

	public class ExitUtil {

		public static function exit() : void {
			if (ExternalInterface.available) {
				ExternalInterface.call("window.close");
			} else {
				System.exit(0);
			}
		}

		public static function reload() : void {
			if (ExternalInterface.available) {
				ExternalInterface.call("window.location.href=window.location.href");
			}
		}
	}
}
