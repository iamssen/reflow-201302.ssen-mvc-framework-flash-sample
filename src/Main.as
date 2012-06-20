package {
	import flash.display.Sprite;
	import flash.events.Event;

	import ssen.mvc.samples.flash.FlashSample;

	public class Main extends Sprite {
		private var cview:FlashSample;

		public function Main() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);

			cview=new FlashSample;
			addChild(cview);
		}

		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(Event.RESIZE, resizeHandler);
			bindSize();
		}

		private function resizeHandler(event:Event):void {
			bindSize();
		}

		private function bindSize():void {
			cview.width=stage.stageWidth;
			cview.height=stage.stageHeight;
		}
	}
}
