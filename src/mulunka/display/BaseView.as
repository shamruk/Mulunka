package mulunka.display {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;

	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;

	import mulunka.display.interfaces.IDepthedView;

	import mx.core.IUIComponent;

	internal class BaseView extends Sprite {

		protected var skin : DisplayObject;
		public var doNotAddSkinToDiaplyList : Boolean = false;
		private var _grabLocationFromSkin : Boolean;
		public var initialized : Boolean = false;

		public function createChildren() : void {
			if (initialized) {
				debug(this, "error: already initialized");
//				return;
			}
			createSkin();
			if (skin) {
				if (_grabLocationFromSkin) {
					x = skin.x;
					y = skin.y;
					skin.x = 0;
					skin.y = 0;
				}
				addChild(skin);
			}
			updateSkinState();
			initialized = true;
		}

		protected function createSkin() : void {
			if (skin) {
				return;
			}
			if (skinClass) {
				skin = new skinClass;
			}
		}

		override public function addChild(view : DisplayObject) : DisplayObject {
			if (!doNotAddSkinToDiaplyList) {
				if (view is IDepthedView && skin is DisplayObjectContainer) {
					DisplayObjectContainer(skin).addChildAt(view, (view as IDepthedView).depth);
				} else {
					super.addChild(view);
				}
			}
			childAdded(view);
			return view;
		}

		override public function addChildAt(child : DisplayObject, index : int) : DisplayObject {
			var displayObject : DisplayObject = super.addChildAt(child, index);
			childAdded(displayObject);
			return displayObject;
		}

		private function childAdded(view : DisplayObject) : void {
			if (view is BaseView) {
				var skinView : BaseView = view as BaseView;
				skinView.createChildren();
			}
			if(view is IUIComponent){
				IUIComponent(view).initialize();
			}
		}

		override public function removeChild(child : DisplayObject) : DisplayObject {
			if (child is BaseView) {
				var view : BaseView = child as BaseView;
				view.unbind();
				//				view.dispatchEvent(new BaseViewEvent(BaseViewEvent.ADDED, view));
			}
			return super.removeChild(child);
		}

		protected function freeze() : void {
			var bitmapData : BitmapData = new BitmapData(skin.width, skin.height, true, 0x00000000);
			bitmapData.draw(skin);
			var staticBG : Bitmap = new Bitmap;
			staticBG.bitmapData = bitmapData;
			removeChild(skin);
			skin = staticBG;
			addChild(skin);
		}

		protected function addBackgroundRectangle(width : uint, height : uint, color : uint, alpha : Number, center : Boolean = false) : void {
			var rect : Shape = new Shape;
			rect.graphics.beginFill(color, alpha);
			rect.graphics.drawRect(0, 0, width, height);
			rect.graphics.endFill();
			if (center) {
				rect.x = -width / 2;
				rect.y = -height / 2;
			}
			addChild(rect);
		}

//		override public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
//			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
//			if(doNotAddSkinToDiaplyList && skin){
//				skin.addEventListener(type, listener, useCapture, priority, useWeakReference);
//			}
//		}

		protected function get skinClass() : Class {
			return null;
		}

		public function set grabLocationFromSkin(value : Boolean) : void {
			_grabLocationFromSkin = value;
		}

		///////////////////
		////  binding  ////
		///////////////////

		private var watchers : Array = [];

		protected function bindProperty(site : Object, prop : String, host : Object, chain : Object) : void {
			var changeWatcher : ChangeWatcher = BindingUtils.bindProperty(site, prop, host, chain);
			watchers.push(changeWatcher);
		}

		protected function bindSetter(setter : Function, host : Object, chain : Object) : void {
			var changeWatcher : ChangeWatcher = BindingUtils.bindSetter(setter, host, chain);
			watchers.push(changeWatcher);
		}

		protected function unbind() : void {
			if (watchers.length) {
				doUnbind();
			}
		}

		protected function doUnbind() : void {
			for each(var watcher : ChangeWatcher in watchers) {
				watcher.unwatch();
			}
			watchers = [];
		}

		//////////////////
		///	SKIN_STATS ///
		//////////////////

		private var _skinState : String;

		protected function get skinState() : String {
			return _skinState;
		}

		protected function set skinState(value : String) : void {
			if (_skinState == value) {
				return;
			}
			_skinState = value;
			updateSkinState();
		}

		private function updateSkinState() : void {
			if (_skinState && skin) {
				MovieClip(skin).gotoAndStop(_skinState);
			}
		}

		///////////////////
		////  		   ////
		///////////////////
	}
}