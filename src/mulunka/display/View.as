package mulunka.display {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.geom.Rectangle;

	import mx.core.IChildList;
	import mx.core.IFactory;
	import mx.core.mx_internal;
	import mx.states.IOverride;
	import mx.states.SetProperty;
	import mx.states.State;

	CONFIG::flex4 {
		import mx.states.AddItems;
	}

	use namespace mx_internal;

	[DefaultProperty("children")]
	public class View extends BaseView implements IChildList {

		private var _width : Number;
		private var _height : Number;
		private var _clipContent : Boolean;

		private var _skinFactory : IFactory;

		private var tempChildren : Vector.<DisplayObject>;
		public var addChildrenImmediately : Boolean = true;

		public function set children(value : Vector.<DisplayObject>) : void {
			if (!value) {
				return;
			}
			if (initialized || addChildrenImmediately) {
				for each(var child : DisplayObject in value) {
					addChild(child);
				}
			} else if (tempChildren) {
				tempChildren = tempChildren.concat(value);
			} else {
				tempChildren = value;
			}
		}

		public function set mxmlContent(value : Array) : void {
			var displays : Vector.<DisplayObject> = new Vector.<DisplayObject>();
			for each(var object : * in value) {
				if (object is DisplayObject) {
					displays.push(object);
				}
			}
			children = displays;
		}

		override public function createChildren() : void {
			super.createChildren();
			children = tempChildren;
			tempChildren = null;
		}

		[Bindable]
		override public function get width() : Number {
			return _width || super.width;
		}

		override public function set width(value : Number) : void {
			_width = value;
			updateClipContent();
		}

		[Bindable]
		override public function get height() : Number {
			return _height || super.height;
		}

		override public function set height(value : Number) : void {
			_height = value;
			updateClipContent();
		}

		[Bindable("addedToStage")]
		override public function get stage() : Stage {
			return super.stage;
		}


		public function getSkinPart(id : String) : DisplayObject {
			createSkin();
			return skin is MovieClip ? MovieClip(skin)[id] : null;
		}

		public function getSkinPartsByType(type : Class) : Vector.<DisplayObject> {
			createSkin();
			var parts : Vector.<DisplayObject> = new Vector.<DisplayObject>();
			var skinContainer : DisplayObjectContainer = skin as DisplayObjectContainer;
			if (skinContainer) {
				for (var i : uint = 0; i < skinContainer.numChildren; i++) {
					var child : DisplayObject = skinContainer.getChildAt(i);
					if (child is type) {
						parts.push(child);
					}
				}
			}
			return parts;
		}

		public function set predefinedSkin(value : DisplayObject) : void {
			skin = value;
		}

		public function set skinFactory(value : IFactory) : void {
			_skinFactory = value;
		}

		override protected function createSkin() : void {
			if (skin) {
				return;
			}
			if (_skinFactory) {
				skin = _skinFactory.newInstance();
			} else {
				super.createSkin();
			}
		}

		///////////////////////
		////  clipContent  ////
		///////////////////////

		[Bindable]
		public function get clipContent() : Boolean {
			return _clipContent;
		}

		public function set clipContent(value : Boolean) : void {
			_clipContent = value;
			updateClipContent();
		}

		private function updateClipContent() : void {
			if (clipContent && scrollRect && scrollRect.width == width && scrollRect.height == height) {
				return;
			}
			if (!clipContent && !scrollRect) {
				return;
			}
			if (!width || !height) {
				return;
			}
			// todo: debug(this, "up", scrollRect);
			scrollRect = new Rectangle(0, 0, width, height);
		}

		//////////////////
		////  states  ////
		//////////////////

		CONFIG::flex4
		{

			[Bindable]
			public var states : Array = [];

			[Bindable]
			public var transitions : Array;

			private var _currentState : String;

			[Bindable]
			public function get currentState() : String {
				return _currentState;
			}

			public function set currentState(value : String) : void {
				removeState(_currentState);
				_currentState = value;
				applyState(_currentState);
			}

			public function reloadState() : void {
				removeState(_currentState);
				applyState(_currentState);
			}

			public function hasState(stateName : String) : Boolean {
				return Boolean(getState(stateName));
			}

			private function removeState(stateName : String) : void {
				var state : State = getState(stateName);
				if (!state) {
					return;
				}
				state.mx_internal::dispatchExitState();
				var overrides : Array = state.overrides;
				for (var i : int = overrides.length; i; i--) {
					var aOverride : IOverride = overrides[i - 1];
					processOverride(aOverride, false);
				}
			}

			private function applyState(stateName : String) : void {
				var state : State = getState(stateName);
				if (!state) {
					return;
				}
				var overrides : Array = state.overrides;
				for (var i : int = 0; i < overrides.length; i++) {
					var aOverride : IOverride = overrides[i];
					tempFixAddItemDepth(aOverride);
					processOverride(aOverride, true);
				}
				state.mx_internal::dispatchEnterState();
			}

			private function processOverride(aOverride : IOverride, apply : Boolean) : void {
				var targetField : String = aOverride is AddItems ? "destination" : (aOverride is SetProperty ? "target" : null);
				var targetName : *;
				if (targetField) {
					targetName = aOverride[targetField];
					aOverride[targetField] = targetName in this ? this[targetName] : this;
				}
				if (apply) {
					aOverride.apply(null);
				} else {
					aOverride.remove(null);
				}
				if (targetField) {
					aOverride[targetField] = targetName;
				}
			}

			/** todo: remove */
			private function tempFixAddItemDepth(aOverride : IOverride) : void {
				if (aOverride is AddItems) {
					AddItems(aOverride).position = AddItems.FIRST;
				}
			}

			private function getState(stateName : String) : State {
				for each(var state : State in states) {
					if (state.name == stateName) {
						return state;
					}
				}
				return null;
			}

		}

		////////////////
		////		////
		////////////////
	}
}