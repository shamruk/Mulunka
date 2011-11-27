package shamm.framework.view {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.ActivityEvent;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.geom.Matrix;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.Dictionary;

	public class CameraHolder extends EventDispatcher {

		public static var mirror : Boolean = false;

		private var camera : Camera;
		private var video : Video = new Video();
		private var matrixMap : Dictionary = new Dictionary(true);

		public var valid : Boolean = true;

		public function CameraHolder() {
			camera = Camera.getCamera();
			if (!camera) {
				valid = false;
				return;
			}

//			camera.setMode(40, 30, 21)

			camera.setQuality(0, 0);

			video.attachCamera(camera);

			if (mirror) {
				video.scaleX = -video.scaleX;
				video.x = video.width;
			}

//			camera.addEventListener(ActivityEvent.ACTIVITY, activityHandler);
//			camera.addEventListener(StatusEvent.STATUS, onCameraStatus);

		}

		private function activityHandler(event : ActivityEvent) : void {
			debug("activity", event.activating);
		}

		private function onCameraStatus(event : StatusEvent) : void {
			debug("camera", event.level, event.code);
		}

		public function render(bitmapData : BitmapData, smooth : Boolean = false) : void {
			if (!matrixMap[bitmapData]) {
				var matrix : Matrix = new Matrix();
				if (mirror) {
					matrix.translate(-video.width, 0);
				}
				matrix.scale((mirror ? -1 : 1) * bitmapData.width / video.width, bitmapData.height / video.height);
				matrixMap[bitmapData] = matrix;
			}
			bitmapData.draw(video, matrixMap[bitmapData], null, null, null, smooth);
		}

		public function getPrivateVideoLink() : DisplayObject {
			return video;
		}

		private static var _instance : CameraHolder;

		public static function get instance() : CameraHolder {
			return _instance || (_instance = new CameraHolder());
		}
	}
}