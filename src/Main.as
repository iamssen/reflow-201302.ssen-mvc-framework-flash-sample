package {
	import flash.display.Sprite;
	import flash.events.Event;
	
	import ssen.mvc.samples.flash.FlashSample;

	public class Main extends Sprite {
		private var cview:FlashSample;

		public function Main() {
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
		}

		private function addedToStageHandler(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

			cview=new FlashSample;
			addChild(cview);
			
			bindSize();

			stage.addEventListener(Event.RESIZE, resizeHandler);
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
