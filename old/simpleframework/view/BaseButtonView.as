package simpleframework.view {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	import mulunka.display.BaseView;

	import simpleframework.utils.MovieClipPlayUtil;

	public class BaseButtonView extends BaseView {

		private var _selected : Boolean = false;
		private var over : Boolean = false;

		public function BaseButtonView(mcSkin : MovieClip = null) {
			super();
			buttonMode = true;
			useHandCursor = true;
			skin = mcSkin;
		}

		override public function createChildren() : void {
			super.createChildren();

			var mc : MovieClip = skin as MovieClip;
			var rect : Rectangle;
			if (mc["hit_mc"]) {
				rect = mc["hit_mc"].getRect(this);
			} else {
				rect = skin.getRect(this);
			}
			var hit : Sprite = new Sprite();
			hit.graphics.beginFill(0, 0);
			hit.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			hit.graphics.endFill();
			addChild(hit);
			hitArea = hit;

			mc.stop();

			addEventListener(MouseEvent.ROLL_OVER, onOver);
			addEventListener(MouseEvent.ROLL_OUT, onOut);
			addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		}

		private function onOver(event : MouseEvent) : void {
			over = true;
			MovieClipPlayUtil.playLabel(buttonSkin, "over");
			//buttonSkin.gotoAndPlay("over");
		}

		private function onOut(event : MouseEvent) : void {
			over = false;
			if (selected) {
				MovieClipPlayUtil.playLabel(buttonSkin, "over");
			} else {
				MovieClipPlayUtil.playLabel(buttonSkin, "out");
			}
		}

		private function onDown(event : MouseEvent) : void {
			MovieClipPlayUtil.playLabel(buttonSkin, "press");
		}


		public function get selected() : Boolean {
			return _selected;
		}

		public function set selected(value : Boolean) : void {
			_selected = value;
			if (selected) {
				MovieClipPlayUtil.playLabel(buttonSkin, "over");
			} else {
				MovieClipPlayUtil.playLabel(buttonSkin, "out");
			}
		}

		public function setMCSkin(value : MovieClip) : void {
			// todo: if skinClass than throw error
			skin = value;
		}

		private function get buttonSkin() : MovieClip {
			return skin as MovieClip;
		}

		//		public function get depth() : uint {
		//			return _depth;
		//		}

	}
}